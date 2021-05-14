matrix worldMatrix;
matrix viewMatrix;
matrix projectionMatrix;

matrix worldMatrixInverse;

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
    return float4(input.normal, 1);
}

technique Normal
{
    pass Pass1
    {
        VertexShader = compile vs_5_0 VertexShaderFunction();
        PixelShader = compile ps_5_0 PixelShaderFunction();
    }
}
