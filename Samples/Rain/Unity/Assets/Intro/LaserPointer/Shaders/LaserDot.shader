// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LaserDot"
{
	Properties
	{
		_DotColor("DotColor", Color) = (1,0.9814457,0.003921568,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		Blend One One , One One
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _DotColor;

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 temp_cast_0 = (( 0.1 * ( ( sin( ( _Time.y * 50.0 ) ) + 15.0 ) * 0.5 ) )).xx;
			float2 temp_output_2_0_g31 = temp_cast_0;
			float temp_output_8_0_g32 = ( ( distance( ( ( ( i.uv_texcoord / temp_output_2_0_g31 ) + 0.5 ) - ( 0.5 / temp_output_2_0_g31 ) ) , float2( 0.5,0.5 ) ) * 1.0 ) / 0.5 );
			float temp_output_1_0_g35 = temp_output_8_0_g32;
			float temp_output_4_0_g32 = 2.33;
			float temp_output_4_0_g35 = ( temp_output_1_0_g35 * temp_output_4_0_g32 );
			int clampResult8_g36 = clamp( (int)( temp_output_4_0_g35 * temp_output_4_0_g35 ) , 0 , 1 );
			float ifLocalVar13_g35 = 0;
			if( temp_output_1_0_g35 <= 0.0 )
				ifLocalVar13_g35 = 1.0;
			else
				ifLocalVar13_g35 = ( 1.0 / pow( 2.7182 , ( ( (float)1 * clampResult8_g36 ) + ( ( 1.0 - clampResult8_g36 ) * temp_output_4_0_g35 ) ) ) );
			int clampResult8_g37 = clamp( 0 , 0 , 1 );
			float temp_output_1_0_g33 = ( 1.0 - temp_output_8_0_g32 );
			float temp_output_4_0_g33 = ( temp_output_1_0_g33 * temp_output_4_0_g32 );
			int clampResult8_g34 = clamp( (int)( temp_output_4_0_g33 * temp_output_4_0_g33 ) , 0 , 1 );
			float ifLocalVar13_g33 = 0;
			if( temp_output_1_0_g33 <= 0.0 )
				ifLocalVar13_g33 = 1.0;
			else
				ifLocalVar13_g33 = ( 1.0 / pow( 2.7182 , ( ( (float)1 * clampResult8_g34 ) + ( ( 1.0 - clampResult8_g34 ) * temp_output_4_0_g33 ) ) ) );
			float4 temp_output_17_0 = ( ( _DotColor * ( ( ifLocalVar13_g35 * clampResult8_g37 ) + ( ( 1.0 - clampResult8_g37 ) * ( 1.0 - ifLocalVar13_g33 ) ) ) ) * 400.0 );
			o.Emission = ( temp_output_17_0 * float4( 1,0,0,0 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
7;29;1906;1014;862.8285;811.0344;1.6;True;True
Node;AmplifyShaderEditor.RangedFloatNode;5;-1262.059,137.1445;Float;False;Constant;_Speed;Speed;0;0;Create;True;0;0;False;0;50;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;1;-1242.988,-85.64713;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-1023.879,-16.90215;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;7;-809.399,-10.97728;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;8;-652.9822,-20.45708;Float;False;ConstantBiasScale;-1;;30;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT;0;False;1;FLOAT;15;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-588.7909,-157.4322;Float;False;Constant;_01;0.1;0;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-319.7326,-114.0999;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-396.5741,-320.4916;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;13;-96.11511,-26.60693;Float;False;ScaleUVsByCenter;-1;;31;90e9fb0cf05e4f44387828896ebc8b6b;0;2;3;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;20;7.771552,211.8258;Float;False;Constant;_GradientDensity;Gradient Density;0;0;Create;True;0;0;False;0;2.33;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;15;475.8558,-328.2438;Float;False;Property;_DotColor;DotColor;1;0;Create;True;0;0;True;0;1,0.9814457,0.003921568,1;1,0.003,0.003,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;25;377.8649,-4.448794;Float;False;RadialGradientExponential;-1;;32;49ad7f947b23e1a43a126bdc6d32a19c;0;5;14;INT;0;False;4;FLOAT;2.333;False;3;FLOAT;0.5;False;2;FLOAT2;0.5,0.5;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;832.3136,-129.4223;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;18;874.2744,163.5717;Float;False;Constant;_Emissive;Emissive;0;0;Create;True;0;0;False;0;400;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;1060.959,-105.2797;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;11;-524.9652,396.4017;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;1295.851,-52.32273;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;797.4557,26.36276;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;12;-103.0222,-317.6558;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;27;1926.642,-10.87694;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;LaserDot;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.5;True;False;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;4;1;False;-1;1;False;-1;4;1;False;-1;1;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;1;0
WireConnection;3;1;5;0
WireConnection;7;0;3;0
WireConnection;8;3;7;0
WireConnection;9;0;10;0
WireConnection;9;1;8;0
WireConnection;13;3;21;0
WireConnection;13;2;9;0
WireConnection;25;4;20;0
WireConnection;25;1;13;0
WireConnection;16;0;15;0
WireConnection;16;1;25;0
WireConnection;17;0;16;0
WireConnection;17;1;18;0
WireConnection;19;0;17;0
WireConnection;22;0;17;0
WireConnection;27;2;19;0
ASEEND*/
//CHKSM=79057733A0AAD3D0D2E321B6C5BCD0A0033B2B8A