// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ASETemplateShaders/testPostProcess"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_VignettePower("_VignettePower", Float) = 13
		_VignetteMode("_VignetteMode", Int) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		
		
		ZTest Always
		Cull Off
		ZWrite Off
		

		Pass
		{ 
			CGPROGRAM 

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform int _VignetteMode;
			uniform float _VignettePower;

			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos ( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float4 _Color0 = float4(1,1,1,0);
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode6 = tex2D( _MainTex, uv_MainTex );
				float temp_output_22_0 = (uv_MainTex).x;
				float temp_output_21_0 = (uv_MainTex).y;
				float temp_output_41_0 = saturate( ( ( ( 1.0 - saturate( pow( temp_output_22_0 , _VignettePower ) ) ) * ( 1.0 - saturate( pow( ( 1.0 - temp_output_22_0 ) , _VignettePower ) ) ) ) * ( ( 1.0 - saturate( pow( temp_output_21_0 , _VignettePower ) ) ) * ( 1.0 - saturate( pow( ( 1.0 - temp_output_21_0 ) , _VignettePower ) ) ) ) ) );
				float4 temp_output_47_0 = ( _Color0 * ( tex2DNode6 * temp_output_41_0 ) );
				float4 ifLocalVar42 = 0;
				if( _VignetteMode <= 1 )
				ifLocalVar42 = temp_output_47_0;
				else
				ifLocalVar42 = ( _Color0 * ( tex2DNode6 + ( 1.0 - temp_output_41_0 ) ) );
				

				finalColor = ifLocalVar42;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
1974;285;1838;614;-149.4169;691.4921;1;True;True
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;7;-812.4681,-182.2866;Float;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-772.2656,-33.1535;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;21;-507.635,36.23596;Float;True;False;True;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;22;-466.7926,-457.0416;Float;True;True;False;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;23;-458.71,-227.1591;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-303.457,-89.81506;Float;False;Property;_VignettePower;_VignettePower;0;0;Create;True;0;0;False;0;13;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;25;-441.0478,308.2429;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;29;-75.78259,302.8779;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;27;-79.18311,25.76996;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;28;-72.38232,-465.5417;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;26;-75.78284,-219.0355;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;33;216.6244,24.07086;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;31;209.8243,-219.0355;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;32;221.7244,301.1774;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;30;226.8254,-465.5417;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;34;451.2303,-219.0355;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;35;464.8304,302.8777;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;36;442.7303,-465.5417;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;37;456.3304,22.37036;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;653.5374,-443.4412;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;658.6354,144.7739;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;837.1414,5.369629;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;17;759.3389,-597.0575;Float;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;41;1036.095,5.933455;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;846.3346,-476.8326;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;49;1207.932,4.587708;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;38;1276.437,-569.0787;Float;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;1354.503,-334.1639;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;1365.276,-232.7038;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;1654.478,-440.6037;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;44;1729.878,-549.8035;Float;False;Constant;_ON1;ON - 1;1;0;Create;True;0;0;False;0;1;0;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;1654.478,-318.4037;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;43;1716.728,-649.4569;Float;False;Property;_VignetteMode;_VignetteMode;1;0;Create;True;0;0;False;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.ConditionalIfNode;42;1952.456,-351.9821;Float;False;False;5;0;INT;0;False;1;INT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2155.821,-337.3679;Float;False;True;2;Float;ASEMaterialInspector;0;1;ASETemplateShaders/testPostProcess;c71b220b631b6344493ea3cf87110c93;0;0;SubShader 0 Pass 0;1;False;False;True;Off;False;False;True;2;True;7;False;True;0;False;0;0;0;False;False;False;False;False;False;False;False;False;True;2;2;;;0;0;1;0;FLOAT4;0,0,0,0;False;0
WireConnection;11;2;7;0
WireConnection;21;0;11;0
WireConnection;22;0;11;0
WireConnection;23;0;22;0
WireConnection;25;0;21;0
WireConnection;29;0;25;0
WireConnection;29;1;24;0
WireConnection;27;0;21;0
WireConnection;27;1;24;0
WireConnection;28;0;22;0
WireConnection;28;1;24;0
WireConnection;26;0;23;0
WireConnection;26;1;24;0
WireConnection;33;0;27;0
WireConnection;31;0;26;0
WireConnection;32;0;29;0
WireConnection;30;0;28;0
WireConnection;34;0;31;0
WireConnection;35;0;32;0
WireConnection;36;0;30;0
WireConnection;37;0;33;0
WireConnection;18;0;36;0
WireConnection;18;1;34;0
WireConnection;19;0;37;0
WireConnection;19;1;35;0
WireConnection;20;0;18;0
WireConnection;20;1;19;0
WireConnection;41;0;20;0
WireConnection;6;0;17;0
WireConnection;49;0;41;0
WireConnection;40;0;6;0
WireConnection;40;1;41;0
WireConnection;45;0;6;0
WireConnection;45;1;49;0
WireConnection;47;0;38;0
WireConnection;47;1;40;0
WireConnection;48;0;38;0
WireConnection;48;1;45;0
WireConnection;42;0;43;0
WireConnection;42;1;44;0
WireConnection;42;2;48;0
WireConnection;42;3;47;0
WireConnection;42;4;47;0
WireConnection;0;0;42;0
ASEEND*/
//CHKSM=8265BEC07D6AE170EF9D9783768F19F23DF51EEF