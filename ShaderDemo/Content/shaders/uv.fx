matrix worldMatrix;
matrix viewMatrix;
matrix projectionMatrix;

struct VSOut
{
    float4 position : POSITION;
    float2 uv :TEXCOORD0;
};

VSOut VertexShaderFunction(float4 position : SV_POSITION, float2 uv : TEXCOORD0)
{
    VSOut Out;

    Out.position = mul(position, mul(worldMatrix, mul(viewMatrix, projectionMatrix)));
    Out.uv = uv;

    return Out;
}

float4 PixelShaderFunction(VSOut input) : COLOR
{
    return float4(input.uv, 0, 1);
}

technique Uv
{
    pass Pass1
    {
        VertexShader = compile vs_5_0 VertexShaderFunction();
        PixelShader = compile ps_5_0 PixelShaderFunction();
    }
}
