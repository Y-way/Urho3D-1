#urhover 1.8.0
#include "Uniforms.glsl"
#include "Samplers.glsl"
#include "Transform.glsl"

#if defined(DIFFMAP) || defined(ALPHAMAP)
    varying vec2 vTexCoord;
#endif
#ifdef VERTEXCOLOR
    varying vec4 vColor;
#endif
#ifdef COMPILEVS
void main()
{
    mat4 modelMatrix = iModelMatrix;
    vec3 worldPos = GetWorldPos(modelMatrix);
    gl_Position = GetClipPos(worldPos);
    
    #ifdef DIFFMAP
        vTexCoord = iTexCoord;
    #endif
    #ifdef VERTEXCOLOR
        vColor = iColor;
    #endif
}
#endif
#ifdef COMPILEPS
void main()
{
    vec4 diffColor = cMatDiffColor;

    #ifdef VERTEXCOLOR
        diffColor *= vColor;
    #endif

    #if (!defined(DIFFMAP)) && (!defined(ALPHAMAP))
        gl_FragColor = diffColor;
    #endif
    #ifdef DIFFMAP
        vec4 diffInput = texture2D(sDiffMap, vTexCoord);
        #ifdef ALPHAMASK
            if (diffInput.a < 0.5)
                discard;
        #endif
        gl_FragColor = diffColor * diffInput;
    #endif
    #ifdef ALPHAMAP
        #ifdef GL3
            float alphaInput = texture2D(sDiffMap, vTexCoord).r;
        #else
            float alphaInput = texture2D(sDiffMap, vTexCoord).a;
        #endif
        gl_FragColor = vec4(diffColor.rgb, diffColor.a * alphaInput);
    #endif
}
#endif
