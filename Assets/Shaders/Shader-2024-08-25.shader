// Made in 44:27
Shader "Unlit/Shader-2024-08-25"
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
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            // inspired by Shader Chaλλenge(https://www.youtube.com/watch?v=2NJrpOFxSSo)
            // thanks for phi16!
            float func (float3 i)
            {
                i.z = frac(cos(i.z)), i.x += i.z*i.y;
                float v = 0;
                v+=asin(sin(i.x))*(1-cos((i.x+i.z)*1.0472));
                v /= 2, i.x /= 2, i.x += i.y*0.5;
                return v;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                col.x = func(i.vertex.zxy*0.02)*0.2+0.1;
                col.y = func(i.vertex.zxy*0.02)*0.05+0.01;
                col.z = 0;
                return col;
            }
            ENDCG
        }
    }
}
