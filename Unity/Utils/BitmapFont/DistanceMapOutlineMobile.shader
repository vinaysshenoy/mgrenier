Shader "Distance Map/Outline" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_AlphaMin ("Alpha Min", Range(0.0,1.0)) = 0.49
		_AlphaMax ("Alpha Max", Range(0.0,1.0)) = 0.54
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags {
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent"
		}
		Lighting Off 
		Cull Off 
		ZTest Always 
		ZWrite Off 
		Fog { Mode Off }
		Blend SrcAlpha OneMinusSrcAlpha

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			half4 _MainTex_ST;
			half4 _Color;
			half _AlphaMin;
			half _AlphaMax;

			struct v2f {
				half4 pos : SV_POSITION;
				half2 uv: TEXCOORD0;
				half3 color : COLOR0;
			};

			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			half4 frag(v2f i) : COLOR
			{
				half4 base = tex2D(_MainTex, i.uv);
				half alpha = smoothstep(_AlphaMin, _AlphaMax, base.w);
				half3 other = _Color * alpha;    
				return half4 (other, alpha);
			}
			ENDCG
		}
	}
}