matrix worldMatrix;
matrix viewMatrix;
matrix projectionMatrix;

matrix worldMatrixInverse;

sampler albedoTexture;

float3 lightDirection;
float3 cameraPosition;
float time;

struct VSOut
{
    float4 position : POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : NORMAL;
};

VSOut VertexShaderFunction(float4 position : SV_POSITION, float3 normal : NORMAL, float2 uv : TEXCOORD0)
{
    VSOut Out;

    Out.normal = normalize(mul(worldMatrixInverse, float4(normal, 0)).xyz);

    // uncomment for funny effect
    // float4 modded = mul(position, worldMatrix) + float4(Out.normal, 0) * tan(time);
    float4 modded = mul(position, worldMatrix) + float4(Out.normal, 0) * sin(time) * .4;
    Out.position = mul(modded, mul(viewMatrix, projectionMatrix));

    Out.uv = uv;

    return Out;
}

// so kann man auch funktionen schreiben:
// specular light amount
// float specular(float3 lookDirection, float3 normal, float3 lightDirection)
// {
//    float3 reflection = reflect(lookDirection, normal);
//    return pow(max(dot(reflection, -lightDirection), 0), 16);
// }

float4 PixelShaderFunction(VSOut input) : COLOR
{
    float ambient = .1;

    float diffuse = max(dot(input.normal, -lightDirection), 0);

    float3 lookDirection = normalize(input.position.xyz - cameraPosition);
    float3 reflection = reflect(lookDirection, input.normal);
    float specular = pow(max(dot(reflection, lightDirection), 0), 16);

    float light = diffuse + specular + ambient;

    float3 color = tex2D(albedoTexture, input.uv).rgb;

    // einkommentieren für "komischer effect"
    // if (color.r > .45) {
    //     discard;
    // }

    return float4(color * light, 1);
}

technique Expand
{
    pass Pass1
    {
        VertexShader = compile vs_5_0 VertexShaderFunction();
        PixelShader = compile ps_5_0 PixelShaderFunction();
    }
}
