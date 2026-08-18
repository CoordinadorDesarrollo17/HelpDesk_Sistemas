using System.Security.Cryptography;

namespace HelpDesk_Sistemas.Common
{
    // Hash de contraseñas con PBKDF2 (nativo de .NET, sin paquetes externos).
    // Formato guardado: "{iteraciones}.{salt en base64}.{hash en base64}".
    public static class PasswordHasher
    {
        private const int SaltSize = 16;
        private const int HashSize = 32;
        private const int Iterations = 100_000;

        public static string Hash(string password)
        {
            var salt = RandomNumberGenerator.GetBytes(SaltSize);
            var hash = Rfc2898DeriveBytes.Pbkdf2(password, salt, Iterations, HashAlgorithmName.SHA256, HashSize);
            return $"{Iterations}.{Convert.ToBase64String(salt)}.{Convert.ToBase64String(hash)}";
        }

        public static bool Verify(string password, string hashedPassword)
        {
            var partes = hashedPassword.Split('.');
            if (partes.Length != 3) return false;

            if (!int.TryParse(partes[0], out var iteraciones)) return false;

            byte[] salt, hashEsperado;
            try
            {
                salt = Convert.FromBase64String(partes[1]);
                hashEsperado = Convert.FromBase64String(partes[2]);
            }
            catch (FormatException)
            {
                return false;
            }

            var hashCalculado = Rfc2898DeriveBytes.Pbkdf2(password, salt, iteraciones, HashAlgorithmName.SHA256, hashEsperado.Length);
            return CryptographicOperations.FixedTimeEquals(hashCalculado, hashEsperado);
        }
    }
}
