using WebApi.Extensions;


var builder = WebApplication.CreateBuilder(args);

// Configurar autenticação JWT
builder.Services.AddCustomAuthentication(builder.Configuration);

// Configurar outros serviços
builder.Services.AddCustomServices(builder.Configuration);

var app = builder.Build();

// Configurar o middleware
app.ConfigureMiddleware();

app.Run();