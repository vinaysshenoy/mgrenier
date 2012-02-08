Shader "Unlit/Transparent Tinted" {
	Properties {
		_Color ("Tint Color", Color) = (1,1,1,0)
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags {
			"Queue"="Transparent"
		}
		LOD 100
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		Pass {
			Lighting Off
			SetTexture [_MainTex] {
				ConstantColor [_Color]
				Combine texture * constant, texture
			}
		}
	} 
	FallBack "Unlit/Transparent"
}
