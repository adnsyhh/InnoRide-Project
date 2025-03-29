namespace App\Http;

use Illuminate\Foundation\Http\Kernel as HttpKernel;

class Kernel extends HttpKernel
{
    // For global middleware (applies to all routes)
    protected $middleware = [
        // ... other middleware
        \App\Http\Middleware\OwnCors::class,
        \Fruitcake\Cors\HandleCors::class,
    ];

    // OR for route middleware (apply selectively to routes)
    protected $routeMiddleware = [
        // ... other middleware
        'own-cors' => \App\Http\Middleware\OwnCors::class,
    ];
} 