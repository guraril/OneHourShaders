// Made in 42:33
Shader "Unlit/Shader-2024-08-26"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldPos = abs(mul(unity_ObjectToWorld, v.vertex));
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                col.x = frac(sin(dot(i.worldPos.xy, float2(abs(sin(0.1))*0.5, 0)))*0.05)*0.5;
                col.y = col.x / frac(abs(cos(dot(i.worldPos.xz*i.vertex.x*abs(sin(_Time.x)), float2(cos(1.5)*0.5, 0))))*0.05)*0.5;
                col.z = col.y/4*frac(cos(i.vertex.y));
                return col;
            }
            ENDCG
        }
    }
}
