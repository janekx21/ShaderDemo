matrix worldMatrix;
matrix viewMatrix;
matrix projectionMatrix;

struct VSOut
{
    float4 position : POSITION;
};

VSOut VertexShaderFunction(float4 position : SV_POSITION)
{
    VSOut Out;
    Out.position = mul(position, mul(worldMatrix, mul(viewMatrix, projectionMatrix)));
    return Out;
}

float4 PixelShaderFunction(VSOut input) : COLOR
{
    return float4(1, 1, 1, 1);
}

technique White
{
    pass Pass1
    {
        VertexShader = compile vs_5_0 VertexShaderFunction();
        PixelShader = compile ps_5_0 PixelShaderFunction();
    }
}
