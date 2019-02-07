// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ghost2"
{
	Properties
	{
		_WispMagnitude("WispMagnitude", Float) = 0.1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_WispSpeed("WispSpeed", Float) = 0.5
		_WispTiling_V("WispTiling_V", Float) = 0.1
		_FaceOffset_U("FaceOffset_U", Float) = 0
		_WispPower2("WispPower2", Float) = 4
		_WispPower("WispPower", Float) = 3
		_WispTiling_U("WispTiling_U", Float) = 2
		_EmissiveBody("EmissiveBody", Float) = 1
		_EmissiveEyes("EmissiveEyes", Float) = 500
		_FaceSize_V("FaceSize_V", Float) = 1
		_FaceOffset_V("FaceOffset_V", Float) = 1
		_FaceSize_U("FaceSize_U", Float) = 1
		_ColorEyes("ColorEyes", Vector) = (1,1,1,1)
		_RippleFade("RippleFade", Float) = 8
		_ColorBody("ColorBody", Vector) = (1,1,1,1)
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_RippleMagnitude("RippleMagnitude", Float) = 0.009
		_FloatMagnitude("FloatMagnitude", Float) = 0
		_RippleSpeed("RippleSpeed", Float) = 9
		_RippleTiling("RippleTiling", Float) = 9
		_FloatSpeed("FloatSpeed", Float) = 9
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float2 uv2_texcoord2;
			float3 worldNormal;
			float3 worldPos;
		};

		uniform sampler2D _TextureSample1;
		uniform float _WispTiling_U;
		uniform float _WispSpeed;
		uniform float _WispTiling_V;
		uniform float _WispPower;
		uniform float _WispPower2;
		uniform float _WispMagnitude;
		uniform float _RippleSpeed;
		uniform float _RippleTiling;
		uniform float _RippleMagnitude;
		uniform float _RippleFade;
		uniform float _FloatSpeed;
		uniform float _FloatMagnitude;
		uniform float4 _ColorBody;
		uniform sampler2D _TextureSample0;
		uniform float _FaceOffset_U;
		uniform float _FaceSize_U;
		uniform float _FaceSize_V;
		uniform float _FaceOffset_V;
		uniform float _EmissiveBody;
		uniform float4 _ColorEyes;
		uniform float _EmissiveEyes;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float temp_output_43_0 = ( _Time.y * 1.0 );
			float2 temp_cast_0 = (_WispSpeed).xx;
			float2 panner37 = ( temp_output_43_0 * temp_cast_0 + v.texcoord.xy);
			float2 appendResult30 = (float2(( _WispTiling_U * (v.texcoord.xy).x ) , ( (panner37).y * _WispTiling_V )));
			float temp_output_45_0 = (v.texcoord.xy).y;
			float temp_output_52_0 = ( tex2Dlod( _TextureSample1, float4( appendResult30, 0, 0.0) ).g + ( pow( temp_output_45_0 , _WispPower ) + pow( temp_output_45_0 , _WispPower2 ) ) );
			float3 ase_vertexNormal = v.normal.xyz;
			float2 temp_cast_1 = (_RippleSpeed).xx;
			float2 panner5_g36 = ( temp_output_43_0 * temp_cast_1 + ( _RippleTiling * v.texcoord.xy ));
			float3 appendResult12_g37 = (float3(float2( 0,0 ) , ( _FloatMagnitude * 0.01 )));
			float3 temp_output_2_0_g37 = ( sin( ( temp_output_43_0 * ( _FloatSpeed * 0.1 ) ) ) * appendResult12_g37 );
			float3 temp_output_68_0 = ( ( ( ( ( temp_output_52_0 * ase_vertexNormal ) * _WispMagnitude ) + ( ( ase_vertexNormal * (sin( panner5_g36 )).x ) * _RippleMagnitude ) ) * pow( ( 1.0 - (v.texcoord.xy).y ) , _RippleFade ) ) + temp_output_2_0_g37 );
			v.vertex.xyz += temp_output_68_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_43_0 = ( _Time.y * 1.0 );
			float2 temp_cast_0 = (_WispSpeed).xx;
			float2 panner37 = ( temp_output_43_0 * temp_cast_0 + i.uv_texcoord);
			float2 appendResult30 = (float2(( _WispTiling_U * (i.uv_texcoord).x ) , ( (panner37).y * _WispTiling_V )));
			float temp_output_45_0 = (i.uv_texcoord).y;
			float temp_output_52_0 = ( tex2D( _TextureSample1, appendResult30 ).g + ( pow( temp_output_45_0 , _WispPower ) + pow( temp_output_45_0 , _WispPower2 ) ) );
			float2 appendResult15_g1 = (float2(( _FaceOffset_U + ( _FaceSize_U * (i.uv2_texcoord2).x ) ) , ( ( (i.uv2_texcoord2).y * _FaceSize_V ) + _FaceOffset_V )));
			float4 tex2DNode16_g1 = tex2D( _TextureSample0, appendResult15_g1 );
			float4 temp_cast_2 = (_EmissiveBody).xxxx;
			float4 temp_cast_4 = (_EmissiveEyes).xxxx;
			o.Emission = ( ( ( ( temp_output_52_0 * ( i.vertexColor * _ColorBody ) ) * tex2DNode16_g1.r ) * temp_cast_2 ) + ( ( tex2DNode16_g1.g * _ColorEyes ) * temp_cast_4 ) ).rgb;
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float4 transform27_g135 = mul(unity_ObjectToWorld,float4( ase_vertexNormal , 0.0 ));
			float3 ase_worldPos = i.worldPos;
			float3 normalizeResult38_g135 = normalize( ( ase_worldPos - _WorldSpaceCameraPos ) );
			float dotResult4_g135 = dot( transform27_g135.xyz , normalizeResult38_g135 );
			float clampResult5_g135 = clamp( dotResult4_g135 , 0.0 , 1.0 );
			int clampResult13_g135 = clamp( 0 , 0 , 1 );
			int clampResult8_g137 = clamp( clampResult13_g135 , 0 , 1 );
			float temp_output_34_0_g135 = ( ( clampResult5_g135 * clampResult8_g137 ) + ( ( 1.0 - clampResult8_g137 ) * dotResult4_g135 ) );
			int clampResult17_g135 = clamp( 1 , 0 , 1 );
			int clampResult8_g138 = clamp( clampResult17_g135 , 0 , 1 );
			float temp_output_35_0_g135 = ( ( temp_output_34_0_g135 * clampResult8_g138 ) + ( ( 1.0 - clampResult8_g138 ) * ( 1.0 - temp_output_34_0_g135 ) ) );
			float lerpResult19_g135 = lerp( 0.0 , 1.0 , temp_output_35_0_g135);
			int clampResult21_g135 = clamp( 0 , 0 , 1 );
			int clampResult8_g136 = clamp( clampResult21_g135 , 0 , 1 );
			o.Alpha = ( ( lerpResult19_g135 * clampResult8_g136 ) + ( ( 1.0 - clampResult8_g136 ) * pow( temp_output_35_0_g135 , 8.0 ) ) );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				fixed4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
				float3 worldPos = IN.worldPos;
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
1927;29;1906;1004;3603.739;1841.192;2.835773;True;False
Node;AmplifyShaderEditor.RangedFloatNode;42;-4372.683,1350.206;Float;False;Constant;_TimeScale;TimeScale;1;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;41;-4367.187,1251.893;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-3449.935,841.9611;Float;False;Property;_WispSpeed;WispSpeed;6;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-4283.716,278.9587;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-4144.358,1281.315;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;97;-3935.921,164.136;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;37;-3927.927,214.8909;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-3659.47,-57.7216;Float;False;Property;_WispTiling_U;WispTiling_U;11;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;96;-3946.307,558.9532;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;34;-3686.614,275.5311;Float;False;False;True;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;33;-3693.535,119.7329;Float;False;True;False;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-3648.809,465.528;Float;False;Property;_WispTiling_V;WispTiling_V;7;0;Create;True;0;0;False;0;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-3410.518,4.736053;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-3164.888,753.1503;Float;False;Property;_WispPower2;WispPower2;9;0;Create;True;0;0;False;0;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-3403.393,370.6512;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-3156.677,653.2617;Float;False;Property;_WispPower;WispPower;10;0;Create;True;0;0;False;0;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;45;-3471.955,596.3629;Float;False;False;True;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;30;-3149.03,215.8151;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;48;-2939.112,709.3634;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;47;-2939.11,565.6875;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-2781.811,618.79;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;28;-2863.192,16.67234;Float;True;Property;_TextureSample1;Texture Sample 1;20;0;Create;True;0;0;False;0;2ccc89be80d2c644890e5b4b63e69eee;2ccc89be80d2c644890e5b4b63e69eee;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-2560.17,302.5342;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;98;-2903.987,828.1577;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-2358.534,574.949;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-2318.203,745.2737;Float;False;Property;_WispMagnitude;WispMagnitude;2;0;Create;True;0;0;False;0;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-2098.905,620.7667;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-1479.562,1243.102;Float;False;Property;_RippleTiling;RippleTiling;24;0;Create;True;0;0;False;0;9;9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-1325.521,1597.537;Float;False;Property;_FloatSpeed;FloatSpeed;25;0;Create;True;0;0;False;0;9;17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-1488.217,1116.847;Float;False;Property;_RippleSpeed;RippleSpeed;23;0;Create;True;0;0;False;0;9;9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-1356.003,1710.361;Float;False;Property;_FloatMagnitude;FloatMagnitude;22;0;Create;True;0;0;False;0;0;5.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-1502.613,989.7656;Float;False;Property;_RippleMagnitude;RippleMagnitude;21;0;Create;True;0;0;False;0;0.009;0.009;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-1469.036,1366.992;Float;False;Property;_RippleFade;RippleFade;18;0;Create;True;0;0;False;0;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;133;-1056.579,1017.45;Float;False;GhostRipples;-1;;36;e9c457459f05ba541956b5aab0d30134;0;6;24;FLOAT3;0,0,0;False;17;FLOAT;0;False;21;FLOAT;0;False;19;FLOAT;0;False;20;FLOAT;0;False;18;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1264.314,-260.9463;Float;False;Property;_FaceOffset_V;FaceOffset_V;15;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;186;-946.6619,-669.8644;Float;False;Property;_ColorEyes;ColorEyes;17;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-1255.729,-174.1488;Float;False;Property;_FaceSize_U;FaceSize_U;16;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;134;-1016.193,1660.372;Float;False;GhostFloating;-1;;37;bab966ac37851b648b41812d6dc8f2d6;0;3;16;FLOAT;0;False;18;FLOAT;0;False;17;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1214.099,-357.5819;Float;False;Property;_EmissiveEyes;EmissiveEyes;13;0;Create;True;0;0;False;0;500;500;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;14;-1180.66,-561.6193;Float;False;Property;_ColorBody;ColorBody;19;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-1248.426,-83.22541;Float;False;Property;_FaceSize_V;FaceSize_V;14;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1016.06,-370.2409;Float;False;Property;_EmissiveBody;EmissiveBody;12;0;Create;True;0;0;False;0;1;52;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1258.679,2.269713;Float;False;Property;_FaceOffset_U;FaceOffset_U;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;122;-656.3072,397.457;Float;False;Constant;_OpacityPower;OpacityPower;18;0;Create;True;0;0;False;0;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;182;-384.7626,402.3561;Float;False;GhostOpacity;-1;;134;f86333141608de54cbc3f6cf70cfc2fa;0;1;11;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;137.4149,1342.047;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;189;-490.8498,-242.8936;Float;False;GhostEmissive;3;;1;3afcba9984ed85f438685ba2ca0bb4a7;0;9;34;FLOAT4;0,0,0,0;False;29;FLOAT4;0,0,0,0;False;28;FLOAT4;0,0,0,0;False;27;FLOAT4;0,0,0,0;False;31;FLOAT;0;False;33;FLOAT;0;False;32;FLOAT;0;False;30;FLOAT;0;False;26;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;158;-2051.384,852.7759;Float;False;GhostWisps;0;;39;5ea70c9e82e1c2445bf1a57a837aca49;0;7;26;FLOAT;0;False;39;FLOAT;0;False;30;FLOAT;0;False;27;FLOAT;0;False;28;FLOAT;0;False;29;FLOAT;0;False;31;FLOAT;0;False;2;FLOAT;35;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-355.2031,987.1439;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;91;-21.36177,1120.143;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;133.0254,-19.51039;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Ghost2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;-1;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;97;0;38;0
WireConnection;37;0;38;0
WireConnection;37;2;39;0
WireConnection;37;1;43;0
WireConnection;96;0;38;0
WireConnection;34;0;37;0
WireConnection;33;0;97;0
WireConnection;31;0;35;0
WireConnection;31;1;33;0
WireConnection;32;0;34;0
WireConnection;32;1;36;0
WireConnection;45;0;96;0
WireConnection;30;0;31;0
WireConnection;30;1;32;0
WireConnection;48;0;45;0
WireConnection;48;1;50;0
WireConnection;47;0;45;0
WireConnection;47;1;49;0
WireConnection;51;0;47;0
WireConnection;51;1;48;0
WireConnection;28;1;30;0
WireConnection;52;0;28;2
WireConnection;52;1;51;0
WireConnection;53;0;52;0
WireConnection;53;1;98;0
WireConnection;54;0;53;0
WireConnection;54;1;55;0
WireConnection;133;24;54;0
WireConnection;133;17;77;0
WireConnection;133;21;43;0
WireConnection;133;19;86;0
WireConnection;133;20;88;0
WireConnection;133;18;80;0
WireConnection;134;16;62;0
WireConnection;134;18;43;0
WireConnection;134;17;63;0
WireConnection;182;11;122;0
WireConnection;90;0;91;0
WireConnection;90;1;68;0
WireConnection;189;34;186;0
WireConnection;189;29;14;0
WireConnection;189;28;4;0
WireConnection;189;27;5;0
WireConnection;189;31;22;0
WireConnection;189;33;24;0
WireConnection;189;32;23;0
WireConnection;189;30;20;0
WireConnection;189;26;52;0
WireConnection;158;26;49;0
WireConnection;158;39;43;0
WireConnection;158;30;39;0
WireConnection;158;27;50;0
WireConnection;158;28;36;0
WireConnection;158;29;35;0
WireConnection;158;31;55;0
WireConnection;68;0;133;0
WireConnection;68;1;134;0
WireConnection;0;2;189;0
WireConnection;0;9;182;0
WireConnection;0;11;68;0
ASEEND*/
//CHKSM=C2813CA4E49C6E9126D41941222838B809EC8540