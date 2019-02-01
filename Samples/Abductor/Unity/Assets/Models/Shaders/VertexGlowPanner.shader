// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Abductor/VertexGlowPanner"
{
	Properties
	{
		_Specular("Specular", Float) = 0
		_HueShift("HueShift", Range( 0 , 255)) = 0
		_BlinkSpeedFactor("BlinkSpeedFactor", Float) = 0
		_Vector0("Vector 0", Vector) = (1,1,1,0)
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Emissive("Emissive", Float) = 40
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
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float3 _Vector0;
		uniform float _HueShift;
		uniform sampler2D _TextureSample0;
		uniform float _BlinkSpeedFactor;
		uniform sampler2D _TextureSample1;
		uniform float _Emissive;
		uniform float _Specular;


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float3 normalizeResult31_g2 = normalize( _Vector0 );
			float3 temp_cast_0 = (0.0).xxx;
			float3 temp_output_29_0_g2 = float4(1,1,1,0).rgb;
			float3 rotatedValue3_g2 = RotateAroundAxis( temp_cast_0, temp_output_29_0_g2, normalize( normalizeResult31_g2 ), _HueShift );
			float2 temp_cast_3 = (( 0.085 * _BlinkSpeedFactor )).xx;
			float2 panner26 = ( _Time.y * temp_cast_3 + i.uv_texcoord);
			float2 temp_cast_4 = (( 0.05 * _BlinkSpeedFactor )).xx;
			float2 panner27 = ( _Time.y * temp_cast_4 + i.uv_texcoord);
			float4 clampResult45 = clamp( ( tex2D( _TextureSample0, panner26 ) * tex2D( _TextureSample1, panner27 ) ) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			o.Emission = ( ( float4( ( rotatedValue3_g2 + temp_output_29_0_g2 ) , 0.0 ) * clampResult45 ) * _Emissive ).rgb;
			float3 temp_cast_6 = (_Specular).xxx;
			o.Specular = temp_cast_6;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
1949;29;1838;1004;3052.494;1791.449;2.639507;True;True
Node;AmplifyShaderEditor.RangedFloatNode;21;-2298.392,103.8287;Float;False;Property;_BlinkSpeedFactor;BlinkSpeedFactor;2;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2105.111,0.1757271;Float;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;False;0;0.085;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-2097.745,207.2087;Float;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;False;0;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;29;-2104.068,-352.8208;Float;True;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1916.95,-1.897342;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1912.804,217.847;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;28;-2092.282,-164.2695;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;26;-1712.603,-127.4494;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;27;-1691.609,189.2648;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;31;-1422.037,161.2766;Float;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;False;0;None;0a5169dc535fc7340925e87d4b745129;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;30;-1420.564,-102.4013;Float;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;False;0;None;0a5169dc535fc7340925e87d4b745129;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1041.988,36.06631;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-1415.796,-519.384;Float;False;Property;_HueShift;HueShift;1;0;Create;True;0;0;False;0;0;0;0;255;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;38;-1382.262,-402.9053;Float;False;Constant;_EmissiveColor;EmissiveColor;4;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;45;-807.7694,36.0668;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;65;-1034.622,-444.1503;Float;True;HueShift;0;;2;2590bed65c6095f4d8b8fbcf6bc650f1;0;2;28;FLOAT;0;False;29;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-491.0604,-21.38317;Float;False;Property;_Emissive;Emissive;5;0;Create;True;0;0;False;0;40;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-577.1428,-236.7216;Float;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;56;-1651.765,-872.0051;Float;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;55;-1621.822,-665.5193;Float;False;Constant;_Color1;Color 1;4;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-1372.822,-818.5187;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-309.8742,-220.2462;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;64;-1041.061,-844.6802;Float;True;HueShift;0;;3;2590bed65c6095f4d8b8fbcf6bc650f1;0;2;28;FLOAT;0;False;29;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-243.8906,126.3289;Float;False;Property;_Specular;Specular;0;0;Create;True;0;0;False;0;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;83.42674,-322.8984;Float;False;True;2;Float;ASEMaterialInspector;0;0;StandardSpecular;Abductor/VertexGlowPanner;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;24;0;22;0
WireConnection;24;1;21;0
WireConnection;25;0;23;0
WireConnection;25;1;21;0
WireConnection;26;0;29;0
WireConnection;26;2;24;0
WireConnection;26;1;28;2
WireConnection;27;0;29;0
WireConnection;27;2;25;0
WireConnection;27;1;28;2
WireConnection;31;1;27;0
WireConnection;30;1;26;0
WireConnection;32;0;30;0
WireConnection;32;1;31;0
WireConnection;45;0;32;0
WireConnection;65;28;59;0
WireConnection;65;29;38;0
WireConnection;46;0;65;0
WireConnection;46;1;45;0
WireConnection;57;0;56;0
WireConnection;57;1;55;0
WireConnection;49;0;46;0
WireConnection;49;1;50;0
WireConnection;64;28;59;0
WireConnection;64;29;57;0
WireConnection;0;2;49;0
WireConnection;0;3;19;0
ASEEND*/
//CHKSM=085632D194971CC08E2282A18B654832D8E0C60E