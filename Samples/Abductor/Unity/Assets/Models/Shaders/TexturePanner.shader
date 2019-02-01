// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TexturePanner"
{
	Properties
	{
		_Smoothness("Smoothness", Float) = 0
		_Specular("Specular", Float) = 0
		_Color("Color", Color) = (0,0,0,0)
		_EmissiveColor("EmissiveColor", Color) = (0,0,0,0)
		_Float0("Float 0", Float) = 1
		_ScrollYSpeed("ScrollYSpeed", Float) = 1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_EmissiveStrength("EmissiveStrength", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
		};

		uniform float4 _Color;
		uniform sampler2D _TextureSample0;
		uniform float _ScrollYSpeed;
		uniform float _Float0;
		uniform float4 _EmissiveColor;
		uniform float _EmissiveStrength;
		uniform float _Specular;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			o.Albedo = ( i.vertexColor * _Color ).rgb;
			float2 temp_cast_1 = (_ScrollYSpeed).xx;
			float2 panner21 = ( _Time.y * temp_cast_1 + i.uv_texcoord);
			float2 temp_cast_2 = (_Float0).xx;
			float2 panner45 = ( _Time.y * temp_cast_2 + i.uv_texcoord);
			float2 appendResult41 = (float2((panner21).x , (panner45).y));
			o.Emission = ( ( tex2D( _TextureSample0, appendResult41 ).a * _EmissiveColor ) * _EmissiveStrength ).rgb;
			float3 temp_cast_4 = (_Specular).xxx;
			o.Specular = temp_cast_4;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
-1500;317;1483;611;862.8145;-335.5406;1.312046;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-1235.88,-148.6761;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-1226.307,-10.07866;Float;False;Property;_Float0;Float 0;4;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;42;-1233.507,80.92136;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1402.279,424.5202;Float;False;Property;_ScrollYSpeed;ScrollYSpeed;5;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;-1411.852,285.9228;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;23;-1409.479,515.5203;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;21;-1113.68,375.6213;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;45;-978.0084,-78.47754;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;46;-708.5512,-3.977842;Float;True;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;47;-798.2513,422.4223;Float;True;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;41;-481.0512,285.9229;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;49;-219.0245,669.8889;Float;False;Property;_EmissiveColor;EmissiveColor;3;0;Create;True;0;0;False;0;0,0,0,0;1,0,0.7797475,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;17;-246.9,104.1;Float;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;False;0;None;8abd8c14ec9d5574d86a7533904aa8e0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;4;-203.6003,-271.0998;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;64.19543,518.3284;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;6;-211.5001,-83.10004;Float;False;Property;_Color;Color;2;0;Create;True;0;0;False;0;0,0,0,0;0.5882353,0.5882353,0.5882353,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;51;-92.16628,862.2704;Float;False;Property;_EmissiveStrength;EmissiveStrength;7;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;97.39989,-139.1001;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2;54.79999,304.4;Float;False;Property;_Specular;Specular;1;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;54.29998,382.8998;Float;False;Property;_Smoothness;Smoothness;0;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;258.6221,694.3839;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;517.0999,168.8;Float;False;True;2;Float;ASEMaterialInspector;0;0;StandardSpecular;TexturePanner;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;40;0
WireConnection;21;2;22;0
WireConnection;21;1;23;0
WireConnection;45;0;44;0
WireConnection;45;2;43;0
WireConnection;45;1;42;0
WireConnection;46;0;45;0
WireConnection;47;0;21;0
WireConnection;41;0;47;0
WireConnection;41;1;46;0
WireConnection;17;1;41;0
WireConnection;48;0;17;4
WireConnection;48;1;49;0
WireConnection;7;0;4;0
WireConnection;7;1;6;0
WireConnection;50;0;48;0
WireConnection;50;1;51;0
WireConnection;0;0;7;0
WireConnection;0;2;50;0
WireConnection;0;3;2;0
WireConnection;0;4;3;0
ASEEND*/
//CHKSM=3411505312A2670AA6CF0691C49501C5FDE90F92