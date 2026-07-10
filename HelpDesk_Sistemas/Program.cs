using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Repositories;
using HelpDesk_Sistemas.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews();

builder.Services.AddSingleton<DapperContext>();

builder.Services.AddTransient<IClientesService, ClientesService>();
builder.Services.AddTransient<IClientesRepository, ClientesRepository>();


var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseRouting();

app.UseAuthorization();

app.MapStaticAssets();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}")
    .WithStaticAssets();


app.Run();
