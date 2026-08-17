using DocumentFormat.OpenXml.InkML;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Repositories;
using HelpDesk_Sistemas.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    var xmlFile = $"{System.Reflection.Assembly.GetExecutingAssembly().GetName().Name}.xml";
    var xmlPath = Path.Combine(AppContext.BaseDirectory, xmlFile);
    c.IncludeXmlComments(xmlPath);
});

builder.Services.AddSingleton<DapperContext>();


builder.Services.AddScoped<ITicketsService, TicketsService>();
builder.Services.AddScoped<ITicketsRepository, TicketsRepository>();
builder.Services.AddScoped<ISlaService, SlaService>();
builder.Services.AddScoped<ISlaRepository, SlaRepository>();
builder.Services.AddHostedService<SlaEngineBackgroundService>();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseRouting();

app.UseAuthorization();

app.MapStaticAssets();

app.Use(async (context, next) =>
{
    try
    {
        await next();
    }
    catch (Microsoft.Data.SqlClient.SqlException ex)
    {
        var logger = context.RequestServices.GetRequiredService<ILogger<Program>>();
        logger.LogError(ex, "Error de base de datos en {Path}", context.Request.Path);

        await ResponderError(context, "No se pudo completar la operaci�n por un problema con la base de datos. Intenta nuevamente.");
    }
    catch (Exception ex)
    {
        var logger = context.RequestServices.GetRequiredService<ILogger<Program>>();
        logger.LogError(ex, "Error no controlado en {Path}", context.Request.Path);

        await ResponderError(context, "Ocurri� un error inesperado. Intenta nuevamente.");
    }
});

async Task ResponderError(HttpContext context, string mensaje)
{
    var esPeticionAjax = context.Request.Headers["X-Requested-With"] == "XMLHttpRequest"
        || context.Request.Headers["Accept"].ToString().Contains("application/json");

    if (esPeticionAjax || context.Request.Method == "POST")
    {
        context.Response.StatusCode = 200; // 200 para que r.json() no falle, el "exito:false" indica el problema
        context.Response.ContentType = "application/json";
        await context.Response.WriteAsync(
            System.Text.Json.JsonSerializer.Serialize(new { exito = false, mensaje })
        );
    }
    else
    {
        context.Response.Redirect("/Home/Error");
    }
}

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}")
    .WithStaticAssets();


app.Run();
