#include "raylib.h"
#include <stdio.h>

int main(void)
{
    const int screenWidth = 800;
    const int screenHeight = 600;

    InitWindow(screenWidth, screenHeight, "Shader Sandbox - Press R to reload");

    // Load shader
    Shader shader = LoadShader(0, "shader.frag");

    // Get shader uniform locations
    int resolutionLoc = GetShaderLocation(shader, "u_resolution");
    int mouseLoc = GetShaderLocation(shader, "u_mouse");
    int timeLoc = GetShaderLocation(shader, "u_time");

    float resolution[2] = { 
      (float)screenWidth, 
      (float)screenHeight 
    };

    SetShaderValue(shader, resolutionLoc, resolution, SHADER_UNIFORM_VEC2);

    float deltaTime = 0.0f;

    while (!WindowShouldClose())
    {
        deltaTime += GetFrameTime();

        Vector2 mouse = GetMousePosition();

        float mousePos[2] = { mouse.x, screenHeight - mouse.y };

        SetShaderValue(shader, mouseLoc, mousePos, SHADER_UNIFORM_VEC2);
        SetShaderValue(shader, timeLoc, &deltaTime, SHADER_UNIFORM_FLOAT);

        // Draw
        BeginDrawing();
            ClearBackground(BLACK);

            BeginShaderMode(shader);
                // Draw fullscreen rectangle
                DrawRectangle(0, 0, screenWidth, screenHeight, RAYWHITE);
            EndShaderMode();

            DrawFPS(10, 40);

        EndDrawing();
    }

    UnloadShader(shader);
    CloseWindow();

    return 0;
}
