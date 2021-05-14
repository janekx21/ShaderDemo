matrix worldMatrix;
matrix viewMatrix;
matrix projectionMatrix;

matrix worldMatrixInverse;

float3 lightDirection;

struct VSOut
{
    float4 position : POSITION;
    float3 normal : NORMAL;
};

VSOut VertexShaderFunction(float4 position : SV_POSITION, float3 normal : NORMAL)
{
    VSOut Out;

    Out.position = mul(position, mul(worldMatrix, mul(viewMatrix, projectionMatrix)));
    Out.normal = normalize(mul(worldMatrixInverse, float4(normal, 0)).xyz);

    return Out;
}

float4 PixelShaderFunction(VSOut input) : COLOR
{
    float light = max(dot(input.normal, -lightDirection), 0);
    return float4(float3(light, light, light), 1);
}

technique BasicLight
{
    pass Pass1
    {
        VertexShader = compile vs_5_0 VertexShaderFunction();
        PixelShader = compile ps_5_0 PixelShaderFunction();
    }
}
