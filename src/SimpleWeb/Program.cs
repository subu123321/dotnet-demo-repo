using System.Reflection;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddRazorPages();

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
}

app.UseStaticFiles();
app.UseRouting();
app.MapRazorPages();

var version = Assembly.GetExecutingAssembly()
    .GetCustomAttribute<AssemblyInformationalVersionAttribute>()?.InformationalVersion ?? "local";

app.MapGet("/health", () => Results.Ok(new
{
    status = "Healthy",
    version,
    server = Environment.MachineName,
    timeUtc = DateTime.UtcNow
}));

app.Run();

public partial class Program { }
