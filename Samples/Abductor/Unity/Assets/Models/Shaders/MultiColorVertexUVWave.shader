// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Abductor/MultiColorVertexUVWave"
{
	Properties
	{
		_TailWaveFactor("TailWaveFactor", Int) = 7
		_HueShift("HueShift", Range( 0 , 255)) = 5
		_Vector0("Vector 0", Vector) = (1,1,1,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.5
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float4 vertexColor : COLOR;
		};

		uniform int _TailWaveFactor;
		uniform float3 _Vector0;
		uniform float _HueShift;


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = _TailWaveFactor;
			float2 temp_cast_1 = (( 1.0 - v.texcoord.xy.y )).xx;
			float2 panner4 = ( 1.0 * _Time.y * temp_cast_0 + temp_cast_1);
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 transform54 = mul(unity_WorldToObject,float4( ase_vertex3Pos , 0.0 ));
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float4 appendResult76 = (float4(0.0 , 0.0 , (( ( ( float4( ( sin( (panner4).xy ) * 5.0 * v.texcoord.xy.y ), 0.0 , 0.0 ) * transform54 ) * float4( ( ( 0.0165 * ase_worldViewDir ) * 2 ) , 0.0 ) ) * float4( pow( (v.texcoord.xy).xy , 0.0 ), 0.0 , 0.0 ) )).y , 0.0));
			v.vertex.xyz += appendResult76.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float3 normalizeResult31_g10 = normalize( _Vector0 );
			float3 temp_cast_0 = (0.0).xxx;
			float3 temp_output_29_0_g10 = ( i.vertexColor * float4(1,1,1,0) ).rgb;
			float3 rotatedValue3_g10 = RotateAroundAxis( temp_cast_0, temp_output_29_0_g10, normalize( normalizeResult31_g10 ), _HueShift );
			o.Albedo = ( rotatedValue3_g10 + temp_output_29_0_g10 );
			float3 temp_cast_2 = 0;
			o.Specular = temp_cast_2;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
1949;29;1838;1004;1951.211;512.5731;1.303205;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;64;-1581.298,-141.1002;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;7;-1220.611,-176.2751;Float;False;Property;_TailWaveFactor;TailWaveFactor;0;0;Create;True;0;0;False;0;7;7;0;1;INT;0
Node;AmplifyShaderEditor.OneMinusNode;63;-1239.314,-412.0574;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;4;-994.9816,-334.4712;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;8;-721.9444,-338.9941;Float;True;True;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-445.6758,-78.90686;Float;False;Constant;_Float1;Float 1;0;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;68;-458.3411,-334.3539;Float;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-650.936,452.99;Float;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;False;0;0.0165;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;34;-652.5361,545.7906;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;66;-952.7181,224.4868;Float;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-170.275,-215.0518;Float;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-387.0934,455.7963;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;35;-388.5349,555.3907;Float;False;Constant;_Int2;Int 2;0;0;Create;True;0;0;False;0;2;0;0;1;INT;0
Node;AmplifyShaderEditor.WorldToObjectTransfNode;54;-628.7427,174.4866;Float;True;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;37;-961.5867,702.9579;Float;True;True;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-97.49411,454.1966;Float;False;2;2;0;FLOAT3;0,0,0;False;1;INT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-150.1734,197.4419;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PowerNode;39;-650.5939,707.9545;Float;True;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;105.7059,354.9962;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;247.1549,682.6313;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.VertexColorNode;1;13.1124,-329.3321;Float;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;77;43.0562,-122.8458;Float;False;Constant;_CatColor;CatColor;2;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;75;412.0273,676.5391;Float;False;False;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;292.0562,-275.8458;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;92;277.8552,63.58969;Float;False;Property;_HueShift;HueShift;1;0;Create;True;0;0;False;0;5;5;0;255;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;90;556.0562,-310.8458;Float;True;HueShift;0;;10;2590bed65c6095f4d8b8fbcf6bc650f1;0;2;28;FLOAT;0;False;29;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;2;851.9982,-11.8827;Float;False;Constant;_Int0;Int 0;0;0;Create;True;0;0;False;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.DynamicAppendNode;76;646.3894,637.0847;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1039.143,-208.3798;Float;False;True;5;Float;ASEMaterialInspector;0;0;StandardSpecular;Abductor/MultiColorVertexUVWave;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;63;0;64;2
WireConnection;4;0;63;0
WireConnection;4;2;7;0
WireConnection;8;0;4;0
WireConnection;68;0;8;0
WireConnection;71;0;68;0
WireConnection;71;1;72;0
WireConnection;71;2;64;2
WireConnection;30;0;31;0
WireConnection;30;1;34;0
WireConnection;54;0;66;0
WireConnection;37;0;64;0
WireConnection;29;0;30;0
WireConnection;29;1;35;0
WireConnection;18;0;71;0
WireConnection;18;1;54;0
WireConnection;39;0;37;0
WireConnection;28;0;18;0
WireConnection;28;1;29;0
WireConnection;36;0;28;0
WireConnection;36;1;39;0
WireConnection;75;0;36;0
WireConnection;78;0;1;0
WireConnection;78;1;77;0
WireConnection;90;28;92;0
WireConnection;90;29;78;0
WireConnection;76;2;75;0
WireConnection;0;0;90;0
WireConnection;0;3;2;0
WireConnection;0;11;76;0
ASEEND*/
//CHKSM=CED470DE4CBC7A5021CC7622F4359D8EDD4F9DDC