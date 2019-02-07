// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Laser"
{
	Properties
	{
		_GradientFalloffUVs("GradientFalloffUVs", Float) = 1
		_BeamColor("BeamColor", Color) = (1,0.003,0.003,1)
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float _GradientFalloffUVs;
		uniform float4 _BeamColor;
		uniform float _Cutoff = 0.5;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 temp_cast_0 = (_GradientFalloffUVs).xx;
			float2 clampResult38 = clamp( ( i.uv_texcoord * _GradientFalloffUVs ) , float2( 0,0 ) , temp_cast_0 );
			float temp_output_40_0 = ( 1.0 - (clampResult38).y );
			float temp_output_43_0 = saturate( temp_output_40_0 );
			float2 temp_cast_1 = (0.5).xx;
			float3 ase_worldPos = i.worldPos;
			float3 temp_output_2_0 = ( ase_worldPos / abs( 0.0025 ) );
			float2 panner9 = ( _Time.y * temp_cast_1 + (temp_output_2_0).xy);
			float2 temp_cast_2 = (0.5).xx;
			float2 panner10 = ( _Time.y * temp_cast_2 + (temp_output_2_0).xz);
			float4 appendResult14 = (float4(panner9 , (panner10).y , 0.0));
			float simplePerlin3D15 = snoise( appendResult14.xyz );
			float2 temp_cast_4 = (-0.25).xx;
			float3 temp_output_27_0 = ( ase_worldPos / abs( 0.005 ) );
			float2 panner18 = ( _Time.y * temp_cast_4 + (temp_output_27_0).xy);
			float2 temp_cast_5 = (-0.25).xx;
			float2 panner19 = ( _Time.y * temp_cast_5 + (temp_output_27_0).xz);
			float4 appendResult21 = (float4(panner18 , (panner19).y , 0.0));
			float simplePerlin3D26 = snoise( appendResult21.xyz );
			float temp_output_16_0 = ( simplePerlin3D15 - simplePerlin3D26 );
			o.Emission = ( temp_output_43_0 * ( ( _BeamColor * temp_output_16_0 ) * 2.0 ) ).rgb;
			float temp_output_46_0 = ( temp_output_43_0 * temp_output_16_0 );
			o.Alpha = temp_output_46_0;
			clip( temp_output_46_0 - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
7;29;1906;1014;2011.563;1148.139;1.236766;True;True
Node;AmplifyShaderEditor.RangedFloatNode;4;-1818.511,86.03722;Float;False;Constant;_WorldScale_1;WorldScale_1;0;0;Create;True;0;0;False;0;0.0025;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1910.686,771.2313;Float;False;Constant;_WorldScale_2;WorldScale_2;0;0;Create;True;0;0;False;0;0.005;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;24;-1692.338,780.5624;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;5;-1600.164,95.36826;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-1721.422,-148.4824;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;25;-1813.596,536.7117;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;27;-1456.43,585.2684;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;2;-1364.256,-99.92573;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;20;-1190.326,722.7096;Float;False;True;False;True;False;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1118.682,289.4547;Float;False;Constant;_NoiseSpeed;NoiseSpeed;0;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;12;-1161.604,181.2144;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;8;-1098.152,37.51548;Float;False;True;False;True;False;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;29;-1253.779,866.4085;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1210.856,974.6488;Float;False;Constant;_NoiseSpeed_1;NoiseSpeed_1;0;0;Create;True;0;0;False;0;-0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;19;-828.2797,771.2313;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;17;-1184.728,575.2784;Float;False;True;True;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;10;-736.1055,86.03719;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;6;-1092.553,-109.9157;Float;False;True;True;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;22;-580.0731,767.4988;Float;False;False;True;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-1482.891,-983.7756;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;37;-1473.498,-822.0925;Float;False;Property;_GradientFalloffUVs;GradientFalloffUVs;0;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;18;-826.4135,571.5459;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;13;-487.899,82.30474;Float;False;False;True;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;9;-734.2393,-113.6482;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1010.787,-969.064;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-258.6378,-36.72754;Float;False;FLOAT4;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;-350.8122,648.4666;Float;False;FLOAT4;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;38;-745.1288,-964.5775;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;15;50.00452,-42.35748;Float;True;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;26;-42.16983,642.8366;Float;True;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;30;707.5711,-195.1981;Float;False;Property;_BeamColor;BeamColor;1;0;Create;True;0;0;False;0;1,0.003,0.003,1;1,0.003,0.003,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;16;350.0061,43.71466;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;39;-415.9865,-950.2671;Float;True;False;True;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;40;-131.5652,-964.5771;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;933.5704,17.34895;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;32;909.3573,146.4913;Float;False;Constant;_Emissive;Emissive;0;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;1132.666,87.30098;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;43;363.9347,-957.4221;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-179.0755,-723.7188;Float;False;Constant;_GradientPowerEnd;GradientPowerEnd;0;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;1370.326,-64.56044;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;928.5652,463.2285;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;44;908.0977,-1086.677;Float;True;Property;_Keyword0;Keyword 0;3;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;784.6705,-832.666;Float;False;Constant;_1;1;0;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;41;142.8691,-855.7192;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1575.285,59.30085;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Laser;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.5;True;False;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;24;0;23;0
WireConnection;5;0;4;0
WireConnection;27;0;25;0
WireConnection;27;1;24;0
WireConnection;2;0;1;0
WireConnection;2;1;5;0
WireConnection;20;0;27;0
WireConnection;8;0;2;0
WireConnection;19;0;20;0
WireConnection;19;2;28;0
WireConnection;19;1;29;0
WireConnection;17;0;27;0
WireConnection;10;0;8;0
WireConnection;10;2;11;0
WireConnection;10;1;12;0
WireConnection;6;0;2;0
WireConnection;22;0;19;0
WireConnection;18;0;17;0
WireConnection;18;2;28;0
WireConnection;18;1;29;0
WireConnection;13;0;10;0
WireConnection;9;0;6;0
WireConnection;9;2;11;0
WireConnection;9;1;12;0
WireConnection;36;0;35;0
WireConnection;36;1;37;0
WireConnection;14;0;9;0
WireConnection;14;2;13;0
WireConnection;21;0;18;0
WireConnection;21;2;22;0
WireConnection;38;0;36;0
WireConnection;38;2;37;0
WireConnection;15;0;14;0
WireConnection;26;0;21;0
WireConnection;16;0;15;0
WireConnection;16;1;26;0
WireConnection;39;0;38;0
WireConnection;40;0;39;0
WireConnection;31;0;30;0
WireConnection;31;1;16;0
WireConnection;33;0;31;0
WireConnection;33;1;32;0
WireConnection;43;0;40;0
WireConnection;34;0;43;0
WireConnection;34;1;33;0
WireConnection;46;0;43;0
WireConnection;46;1;16;0
WireConnection;44;1;45;0
WireConnection;44;0;43;0
WireConnection;41;0;40;0
WireConnection;41;1;42;0
WireConnection;0;2;34;0
WireConnection;0;9;46;0
WireConnection;0;10;46;0
ASEEND*/
//CHKSM=D21E7DEB1D18143641788D70CE92013D4C2C5719