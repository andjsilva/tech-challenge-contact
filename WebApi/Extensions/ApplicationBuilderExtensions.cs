
using Prometheus;

namespace WebApi.Extensions
{
    public static class ApplicationBuilderExtensions
    {
        public static void ConfigureMiddleware(this WebApplication app)
        {
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseHttpsRedirection();
            app.UseAuthentication();  
            app.UseAuthorization();
            
            // Configura o endpoint de métricas do Prometheus
            app.UseMetricServer();

            // Configura a coleta de métricas padrão de ASP.NET Core
            app.UseHttpMetrics();

            // Garante que o endpoint de métricas está mapeado
            app.MapMetrics();

            app.MapControllers();
        }
    }
}