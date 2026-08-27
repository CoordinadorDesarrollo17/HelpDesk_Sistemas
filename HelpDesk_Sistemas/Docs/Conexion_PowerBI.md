# Conexión de Power BI a HelpDesk Sistemas

API de solo lectura pensada para que Gerencia arme sus propios reportes en Power BI, sin
depender de las pantallas de Reportes ya existentes en el sistema. Devuelve datos planos
(tabla de hechos de tickets + catálogos/dimensiones) para que se pueda modelar libremente.

## Autenticación

Todos los endpoints requieren el header `X-Api-Key` con la clave configurada en
`appsettings.json` → `PowerBi:ApiKey`. Sin ese header (o con un valor incorrecto), el servidor
responde `401 Unauthorized`.

La clave es una sola, compartida para esta integración (no es la contraseña de ningún usuario
del sistema). Pídesela al área de Sistemas — no se expone en ningún endpoint ni pantalla.

## Endpoints disponibles

Base: `http://<servidor>:<puerto>/api/powerbi`

| Endpoint | Descripción |
|---|---|
| `GET /tickets?fechaInicio=2026-01-01&fechaFin=2026-12-31` | Un ticket por fila (toda la organización, sin límite de filas), con Sociedad, Área, Área Solicitante, Tipo de atención, Categoría, Sistema, Estado, Prioridad, Impacto, Urgencia, fechas, y el SLA de Respuesta/Resolución ya aplanado en la misma fila. `fechaInicio`/`fechaFin` son opcionales (filtran por `Fecha_Creacion`); sin ellos, trae todo. |
| `GET /departamentos` | Id, Nombre, Prefijo. |
| `GET /areas` | Id, Nombre, Departamento al que pertenece, y si es una de las 3 áreas de soporte. |
| `GET /sociedades` | Id, Nombre. |
| `GET /tipos-atencion` | Id, Nombre, Área a la que pertenece, Flujo (Soporte / ImplementacionMejora). |
| `GET /categorias` | Id, Nombre, Tipo de atención y Área a la que pertenece. |
| `GET /sistemas` | Id, Nombre (SAP B1, SOPHOS, etc.). |
| `GET /estados` | Id, Nombre (Pendiente, En atención, Cerrado, ...). |
| `GET /prioridades` | Id, Nombre (Baja, Media, Alta, Urgente). |
| `GET /usuarios` | Id, Nombre, Apellido, Usuario, Rol, Área, Departamento, Sociedades, Activo. Nunca incluye la contraseña. |

Todas las respuestas son JSON plano (un array de objetos), listo para que Power Query lo
convierta en tabla sin expandir columnas anidadas.

## Paso a paso en Power BI Desktop

1. **Inicio → Transformar Datos**. Esto abrirá el **Editor de Power Query**.
2. **Inicio → Editor avanzado**. Normalmente está dentro de la cinta de opciones, hacia la derecha.
3. Se abrirá el editor, ahi debes pegar este código M:

   ```
   let
       Origen = Json.Document(
           Web.Contents(
               "http://192.168.1.52:6767/api/powerbi/tickets",
               [Headers = [#"X-Api-Key" = "72cb0e18bdee44b585364aac6f1fb47f837af87aa687436b88cb3be900840461"]]
           )
       ),
       Tabla = Table.FromList(Origen, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
       Expandida = Table.ExpandRecordColumn(Tabla, "Column1",
           {"id","codigoTicket","sociedad","area","areaSolicitante","tipoAtencion","flujo",
            "categoria","sistema","estado","prioridad","impacto","urgencia","solicitante",
            "asignado","fechaCreacion","fechaAsignacion","fechaAtencion","fechaCierre",
            "slaRespuestaEtapa","slaRespuestaPorcentajeConsumido","slaRespuestaIncumplido",
            "slaResolucionEtapa","slaResolucionPorcentajeConsumido","slaResolucionIncumplido"})
   in
       Expandida
   ```

4. Repite por cada endpoint de catálogo que quieras usar (`areas`, `departamentos`,
   `tipos-atencion`, etc.) y arma las relaciones en el modelo de Power BI como cualquier
   otra fuente.
5. Guarda el archivo `.pbix`: cualquiera en Gerencia que lo abra y tenga acceso a la red
   interna puede hacer clic en **Actualizar** para traer los datos más recientes.

## Limitación a tener en cuenta

Este API vive dentro de la red interna de la empresa (no es accesible desde internet). Eso
significa que **Power BI Desktop funciona directo**, pero si más adelante quieren publicar el
reporte a Power BI Service y programar una actualización automática en la nube, van a
necesitar instalar un **Gateway de datos local (on-premises data gateway)** en un equipo
dentro de la red — eso es una instalación de infraestructura, no un cambio de este sistema.
