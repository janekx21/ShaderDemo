matrix worldMatrix;
matrix viewMatrix;
matrix projectionMatrix;

matrix worldMatrixInverse;

sampler albedoTexture;

struct VSOut
{
    float4 position : POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : NORMAL;
};

VSOut VertexShaderFunction(float4 position : SV_POSITION, float3 normal : NORMAL, float2 uv : TEXCOORD0)
{
    VSOut Out;

    Out.position = mul(position, mul(worldMatrix, mul(viewMatrix, projectionMatrix)));
    Out.normal = normalize(mul(worldMatrixInverse, float4(normal, 0)).xyz);
    Out.uv = uv;

    return Out;
}

float4 PixelShaderFunction(VSOut input) : COLOR
{
    float3 color = tex2D(albedoTexture, input.uv).rgb;
    return float4(color, 1);
}

technique Textured
{
    pass Pass1
    {
        VertexShader = compile vs_5_0 VertexShaderFunction();
        PixelShader = compile ps_5_0 PixelShaderFunction();
    }
}
