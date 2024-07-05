using WebApi.Infrastructure.Context;

namespace WebApi.Infrastructure.Extensions;

public static class DatabaseMigrationExtensions
{
    public static IApplicationBuilder MigrateDatabase(this IApplicationBuilder app)
    {
        using (var scope = app.ApplicationServices.CreateScope())
        {
            var services = scope.ServiceProvider;
            var dbContext = services.GetRequiredService<TechChallenge1DbContext>();
            Task.WaitAll(dbContext.MigrateAsync());
        }

        return app;
    }
}