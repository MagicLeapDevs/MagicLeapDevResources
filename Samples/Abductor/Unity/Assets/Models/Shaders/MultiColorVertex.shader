// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Abductor/MultiColorVertex"
{
	Properties
	{
		_Smoothness("Smoothness", Float) = 0
		[Header(HueShift)]
		_Specular("Specular", Float) = 0
		_Vector0("Vector 0", Vector) = (1,1,1,0)
		_HueShift("HueShift", Range( 0 , 255)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 4.5
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float4 vertexColor : COLOR;
		};

		uniform float3 _Vector0;
		uniform float _HueShift;
		uniform float _Specular;
		uniform float _Smoothness;


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
			float3 normalizeResult31_g11 = normalize( _Vector0 );
			float3 temp_cast_0 = (0.0).xxx;
			float3 temp_output_29_0_g11 = ( i.vertexColor * float4(1,1,1,0) ).rgb;
			float3 rotatedValue3_g11 = RotateAroundAxis( temp_cast_0, temp_output_29_0_g11, normalize( normalizeResult31_g11 ), _HueShift );
			o.Albedo = ( rotatedValue3_g11 + temp_output_29_0_g11 );
			float3 temp_cast_2 = (_Specular).xxx;
			o.Specular = temp_cast_2;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15201
1927;48;1820;979;840.7672;591.3981;1.3;True;False
Node;AmplifyShaderEditor.ColorNode;79;-280.1382,-169.4879;Float;False;Constant;_Color0;Color 0;4;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;78;-310.0819,-375.9742;Float;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-31.13825,-322.4879;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-72.63928,-23.3524;Float;False;Property;_HueShift;HueShift;2;0;Create;True;0;0;False;0;0;5;0;255;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;83;232.8618,-357.4879;Float;True;HueShift;0;;11;2590bed65c6095f4d8b8fbcf6bc650f1;0;2;28;FLOAT;0;False;29;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;77;498.2335,-72.69833;Float;False;Property;_Specular;Specular;1;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;507.7528,20.56981;Float;False;Property;_Smoothness;Smoothness;0;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;799.1425,-164.3798;Float;False;True;5;Float;ASEMaterialInspector;0;0;StandardSpecular;Abductor/MultiColorVertex;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;81;0;78;0
WireConnection;81;1;79;0
WireConnection;83;28;80;0
WireConnection;83;29;81;0
WireConnection;0;0;83;0
WireConnection;0;3;77;0
WireConnection;0;4;74;0
ASEEND*/
//CHKSM=5146FDA3886C814FB54EBB22A7008A45EE43E1C4