// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ghost2"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_WispTiling_V("WispTiling_V", Float) = 0.1
		_FaceOffset_U("FaceOffset_U", Float) = 0
		_WispSpeed("WispSpeed", Float) = -0.5
		_WispTiling_U("WispTiling_U", Float) = 2
		_EmissiveBody("Emissive Body", Float) = 52
		_EmissiveEyes("Emissive Eyes", Float) = 500
		_FaceSize_V("FaceSize_V", Float) = 1
		_FaceOffset_V("FaceOffset_V", Float) = 1
		_FaceSize_U("FaceSize_U", Float) = 1
		_ColorEyes("ColorEyes", Vector) = (1,1,1,1)
		_ColorBody("ColorBody", Vector) = (1,1,1,1)
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float2 uv2_texcoord2;
		};

		uniform sampler2D _TextureSample1;
		uniform float _WispTiling_U;
		uniform float _WispSpeed;
		uniform float _WispTiling_V;
		uniform float4 _ColorBody;
		uniform sampler2D _TextureSample0;
		uniform float _FaceOffset_U;
		uniform float _FaceSize_U;
		uniform float _FaceSize_V;
		uniform float _FaceOffset_V;
		uniform float _EmissiveBody;
		uniform float4 _ColorEyes;
		uniform float _EmissiveEyes;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_WispSpeed).xx;
			float2 panner37 = ( ( _Time.y * 1.0 ) * temp_cast_0 + i.uv_texcoord);
			float2 appendResult30 = (float2(( _WispTiling_U * (i.uv_texcoord).x ) , ( (panner37).y * _WispTiling_V )));
			float4 tex2DNode28 = tex2D( _TextureSample1, appendResult30 );
			float2 appendResult15 = (float2(( _FaceOffset_U + ( _FaceSize_U * (i.uv2_texcoord2).x ) ) , ( ( (i.uv2_texcoord2).y * _FaceSize_V ) + _FaceOffset_V )));
			float4 tex2DNode1 = tex2D( _TextureSample0, appendResult15 );
			o.Emission = ( ( ( ( ( tex2DNode28 + float4( 0,0,0,0 ) ) * ( i.vertexColor * _ColorBody ) ) * tex2DNode1.r ) * _EmissiveBody ) + ( ( tex2DNode1.g * _ColorEyes ) * _EmissiveEyes ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
1927;29;1906;1004;2621.885;993.6071;1.895083;True;True
Node;AmplifyShaderEditor.SimpleTimeNode;41;-3863.369,868.7529;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-3868.865,967.0668;Float;False;Constant;_TimeScale;TimeScale;1;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-3831.548,307.2761;Float;False;Property;_WispSpeed;WispSpeed;4;0;Create;True;0;0;False;0;-0.5;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-3640.541,898.175;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-3894.093,125.7072;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;37;-3572.071,212.2934;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;33;-3337.68,117.1354;Float;False;True;False;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-3307.665,433.5038;Float;False;Property;_WispTiling_V;WispTiling_V;2;0;Create;True;0;0;False;0;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-3303.615,-60.31906;Float;False;Property;_WispTiling_U;WispTiling_U;7;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;34;-3330.758,272.9337;Float;False;False;True;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-2278.439,-224.8096;Float;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-1897.173,-368.7097;Float;False;Property;_FaceSize_U;FaceSize_U;12;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1899.041,-10.07969;Float;False;Property;_FaceSize_V;FaceSize_V;10;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;25;-1930.796,-247.2984;Float;False;True;False;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;26;-1928.927,-155.7734;Float;False;False;True;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-3054.662,2.138579;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-3047.537,368.0538;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;30;-2793.174,213.2176;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1652.483,-279.0525;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1701.046,51.55994;Float;False;Property;_FaceOffset_V;FaceOffset_V;11;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1654.35,-103.473;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1686.105,-426.614;Float;False;Property;_FaceOffset_U;FaceOffset_U;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-1442.271,-57.16393;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-1448.979,-343.0728;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;13;-1040.878,-699.3264;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;28;-2578.05,183.7883;Float;True;Property;_TextureSample1;Texture Sample 1;15;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;14;-1051.484,-478.2078;Float;False;Property;_ColorBody;ColorBody;14;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-2099.608,208.5279;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-806.5529,-560.3904;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;-1276.863,-222.7999;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;9;-763.053,-24.62121;Float;False;Property;_ColorEyes;ColorEyes;13;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-640.6594,-659.9265;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-839.3207,-249.8773;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-394.1289,-1.563492;Float;False;Property;_EmissiveEyes;Emissive Eyes;9;0;Create;True;0;0;False;0;500;500;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-379.9393,-120.3995;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-399.4502,-217.9513;Float;False;Property;_EmissiveBody;Emissive Body;8;0;Create;True;0;0;False;0;52;52;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-429.4078,-339.4612;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-197.2514,-260.5195;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-191.9304,-89.20267;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-2147.46,621.3393;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-3164.888,753.1503;Float;False;Property;_WispPower2;WispPower2;5;0;Create;True;0;0;False;0;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;57;-2527.583,792.8495;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-2718.811,621.79;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-42.9419,-175.3833;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-2150.002,812.2436;Float;False;Constant;_WispMagnitude;WispMagnitude;1;0;Create;True;0;0;False;0;5.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-3156.677,653.2617;Float;False;Property;_WispPower;WispPower;6;0;Create;True;0;0;False;0;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;44;-3075.627,848.9669;Float;False;Tangent;4;0;FLOAT3;0,0,1;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;45;-3422.055,567.4944;Float;False;False;True;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-2377.948,620.7155;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;46;-3152.393,571.4313;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-1887.831,667.157;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;48;-2939.112,709.3634;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;47;-2939.11,565.6875;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;133.0254,-19.51039;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Ghost2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;37;0;38;0
WireConnection;37;2;39;0
WireConnection;37;1;43;0
WireConnection;33;0;38;0
WireConnection;34;0;37;0
WireConnection;25;0;27;0
WireConnection;26;0;27;0
WireConnection;31;0;35;0
WireConnection;31;1;33;0
WireConnection;32;0;34;0
WireConnection;32;1;36;0
WireConnection;30;0;31;0
WireConnection;30;1;32;0
WireConnection;18;0;23;0
WireConnection;18;1;25;0
WireConnection;19;0;26;0
WireConnection;19;1;24;0
WireConnection;17;0;19;0
WireConnection;17;1;22;0
WireConnection;16;0;20;0
WireConnection;16;1;18;0
WireConnection;28;1;30;0
WireConnection;29;0;28;0
WireConnection;11;0;13;0
WireConnection;11;1;14;0
WireConnection;15;0;16;0
WireConnection;15;1;17;0
WireConnection;12;0;29;0
WireConnection;12;1;11;0
WireConnection;1;1;15;0
WireConnection;2;0;1;2
WireConnection;2;1;9;0
WireConnection;3;0;12;0
WireConnection;3;1;1;1
WireConnection;6;0;3;0
WireConnection;6;1;4;0
WireConnection;7;0;2;0
WireConnection;7;1;5;0
WireConnection;53;0;52;0
WireConnection;53;1;57;0
WireConnection;51;0;47;0
WireConnection;51;1;48;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;45;0;38;0
WireConnection;52;0;28;2
WireConnection;52;1;51;0
WireConnection;46;0;45;0
WireConnection;54;0;53;0
WireConnection;54;1;55;0
WireConnection;48;0;46;0
WireConnection;48;1;50;0
WireConnection;47;0;46;0
WireConnection;47;1;49;0
WireConnection;0;2;8;0
ASEEND*/
//CHKSM=8A65438784ECDDDDD6952CD63BD735E9C6BFA6E4