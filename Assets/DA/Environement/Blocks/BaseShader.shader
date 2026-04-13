// Upgrade NOTE: upgraded instancing buffer 'MainShader' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MainShader"
{
	Properties
	{
		_ShadowDetailShape("ShadowDetailShape", 2D) = "black" {}
		_ShadowStrenght("ShadowStrenght", Range( 0 , 1)) = 0.596083
		_BaseColor("Base Color", Color) = (1,0.2399642,0,0)
		_ShadowSize("ShadowSize", Range( 0.5 , 2)) = 1.43935
		_LightSize("LightSize", Range( 0.5 , 2)) = 1.12274
		_ShadowBias("ShadowBias", Range( 0 , 1)) = 0
		_LEDsShape("LEDsShape", 2D) = "black" {}
		_ShadowTilling("ShadowTilling", Float) = 1
		_Preset("Preset", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
		};

		uniform sampler2D _ShadowDetailShape;
		uniform sampler2D _LEDsShape;

		UNITY_INSTANCING_BUFFER_START(MainShader)
			UNITY_DEFINE_INSTANCED_PROP(float4, _BaseColor)
#define _BaseColor_arr MainShader
			UNITY_DEFINE_INSTANCED_PROP(float4, _LEDsShape_ST)
#define _LEDsShape_ST_arr MainShader
			UNITY_DEFINE_INSTANCED_PROP(float, _ShadowBias)
#define _ShadowBias_arr MainShader
			UNITY_DEFINE_INSTANCED_PROP(float, _LightSize)
#define _LightSize_arr MainShader
			UNITY_DEFINE_INSTANCED_PROP(float, _ShadowTilling)
#define _ShadowTilling_arr MainShader
			UNITY_DEFINE_INSTANCED_PROP(float, _ShadowSize)
#define _ShadowSize_arr MainShader
			UNITY_DEFINE_INSTANCED_PROP(float, _ShadowStrenght)
#define _ShadowStrenght_arr MainShader
			UNITY_DEFINE_INSTANCED_PROP(float, _Preset)
#define _Preset_arr MainShader
		UNITY_INSTANCING_BUFFER_END(MainShader)


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV65 = dot( ase_worldNormal, ase_worldlightDir );
			float fresnelNode65 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV65, 0.5 ) );
			float _ShadowBias_Instance = UNITY_ACCESS_INSTANCED_PROP(_ShadowBias_arr, _ShadowBias);
			float _LightSize_Instance = UNITY_ACCESS_INSTANCED_PROP(_LightSize_arr, _LightSize);
			float fresnelNdotV135 = dot( ase_worldNormal, ase_worldlightDir );
			float fresnelNode135 = ( _ShadowBias_Instance + ( _LightSize_Instance - 0.05 ) * pow( 1.0 - fresnelNdotV135, -1.0 ) );
			float lerpResult87 = lerp( 0.0 , 1.0 , ( ( 1.0 - fresnelNode135 ) * 1.0 ));
			float _ShadowTilling_Instance = UNITY_ACCESS_INSTANCED_PROP(_ShadowTilling_arr, _ShadowTilling);
			float2 temp_cast_0 = (_ShadowTilling_Instance).xx;
			float2 uv_TexCoord83 = i.uv_texcoord * temp_cast_0;
			float4 tex2DNode35 = tex2D( _ShadowDetailShape, uv_TexCoord83 );
			float blendOpSrc98 = lerpResult87;
			float blendOpDest98 = tex2DNode35.r;
			float3 temp_cast_1 = (( 1.0 - ( saturate( (( blendOpSrc98 > 0.5 )? ( blendOpDest98 + 2.0 * blendOpSrc98 - 1.0 ) : ( blendOpDest98 + 2.0 * ( blendOpSrc98 - 0.5 ) ) ) )) )).xxx;
			float temp_output_2_0_g12 = 25.0;
			float temp_output_3_0_g12 = ( 1.0 - temp_output_2_0_g12 );
			float3 appendResult7_g12 = (float3(temp_output_3_0_g12 , temp_output_3_0_g12 , temp_output_3_0_g12));
			float LightShape231 = floor( ( ( temp_cast_1 * temp_output_2_0_g12 ) + appendResult7_g12 ).x );
			float temp_output_293_0 = ( 1.0 - LightShape231 );
			float _ShadowSize_Instance = UNITY_ACCESS_INSTANCED_PROP(_ShadowSize_arr, _ShadowSize);
			float fresnelNdotV134 = dot( ase_worldNormal, ( float3(-1,-1,-1) * ase_worldlightDir ) );
			float fresnelNode134 = ( _ShadowBias_Instance + ( _ShadowSize_Instance - 0.05 ) * pow( 1.0 - fresnelNdotV134, -1.0 ) );
			float lerpResult81 = lerp( 0.0 , 1.0 , ( 1.0 * ( 1.0 - fresnelNode134 ) ));
			float blendOpSrc82 = lerpResult81;
			float blendOpDest82 = tex2DNode35.r;
			float3 temp_cast_2 = (( 1.0 - ( saturate( (( blendOpSrc82 > 0.5 )? ( blendOpDest82 + 2.0 * blendOpSrc82 - 1.0 ) : ( blendOpDest82 + 2.0 * ( blendOpSrc82 - 0.5 ) ) ) )) )).xxx;
			float temp_output_2_0_g11 = 25.0;
			float temp_output_3_0_g11 = ( 1.0 - temp_output_2_0_g11 );
			float3 appendResult7_g11 = (float3(temp_output_3_0_g11 , temp_output_3_0_g11 , temp_output_3_0_g11));
			float ShadowShape142 = floor( ( ( temp_cast_2 * temp_output_2_0_g11 ) + appendResult7_g11 ).x );
			float temp_output_292_0 = ( 1.0 - ShadowShape142 );
			float _ShadowStrenght_Instance = UNITY_ACCESS_INSTANCED_PROP(_ShadowStrenght_arr, _ShadowStrenght);
			float clampResult297 = clamp( ( ( step( ( ( 0.0 + ( fresnelNode65 * 0.5 ) ) + 0.5 ) , 2.0 ) - temp_output_293_0 ) - temp_output_292_0 ) , 0.0 , _ShadowStrenght_Instance );
			float clampResult296 = clamp( temp_output_292_0 , 0.0 , ( _ShadowStrenght_Instance / 2.0 ) );
			float Lighting118 = saturate( ( clampResult297 + temp_output_293_0 + clampResult296 ) );
			float4 _BaseColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_BaseColor_arr, _BaseColor);
			float4 _LEDsShape_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_LEDsShape_ST_arr, _LEDsShape_ST);
			float2 uv_LEDsShape = i.uv_texcoord * _LEDsShape_ST_Instance.xy + _LEDsShape_ST_Instance.zw;
			float4 tex2DNode42 = tex2D( _LEDsShape, uv_LEDsShape );
			float4 clampResult48 = clamp( ( ( Lighting118 * _BaseColor_Instance ) - tex2DNode42 ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float _Preset_Instance = UNITY_ACCESS_INSTANCED_PROP(_Preset_arr, _Preset);
			float3 hsvTorgb307 = RGBToHSV( _BaseColor_Instance.rgb );
			float3 hsvTorgb311 = HSVToRGB( float3(( _Preset_Instance + hsvTorgb307.x ),1.0,1.0) );
			o.Emission = ( clampResult48 + ( tex2DNode42 * float4( hsvTorgb311 , 0.0 ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows 

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
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;4886.9,-119.1609;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;98;417.3871,1163.859;Inherit;True;LinearLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;82;438.2448,703.5027;Inherit;True;LinearLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;35;-220.8232,934.1228;Inherit;True;Property;_ShadowDetailShape;ShadowDetailShape;0;0;Create;True;0;0;0;False;0;False;-1;d00d1b2aafe502141bea5ca9a9b145dd;d00d1b2aafe502141bea5ca9a9b145dd;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;136;-699.5985,1154.258;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;99;1067.149,825.9291;Inherit;True;Lerp White To;-1;;11;047d7c189c36a62438973bad9d37b1c2;0;2;1;FLOAT3;0,0,0;False;2;FLOAT;25;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;105;1051.298,1177.067;Inherit;True;Lerp White To;-1;;12;047d7c189c36a62438973bad9d37b1c2;0;2;1;FLOAT3;0,0,0;False;2;FLOAT;25;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;44;5808.672,-134.5378;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;104;785.1116,1184.576;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;100;800.6719,786.1992;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;234;1708.167,822.3611;Inherit;True;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;235;1727.667,1152.561;Inherit;True;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FloorOpNode;241;1947.767,1180.421;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;236;1925.067,842.1609;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;2014.487,1024.821;Inherit;False;InstancedProperty;_ShadowDetailStrenght;ShadowDetailStrenght;2;0;Create;True;0;0;0;False;0;False;0.3039514;0.378;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;242;2386.767,1180.421;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;231;2704.301,1228.203;Inherit;True;LightShape;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;142;2713.249,773.4601;Inherit;True;ShadowShape;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;237;2381.167,799.6609;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;87;55.22187,1180.778;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;132;-686.0938,744.9897;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;286;-1735.803,1113.345;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FresnelNode;134;-1041.446,708.0592;Inherit;True;Standard;WorldNormal;LightDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1.78;False;3;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;81;-0.5276222,701.8079;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;284;-1992.635,1036.57;Inherit;False;Constant;_Vector0;Vector 0;9;0;Create;True;0;0;0;False;0;False;-1,-1,-1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;261;-2053.281,1257.15;Inherit;True;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;255;-1437.924,544.0111;Inherit;False;2;0;FLOAT;2;False;1;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-328.1541,703.863;Inherit;True;2;2;0;FLOAT;1;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-233.6641,1161.852;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;135;-1032.997,1154.102;Inherit;True;Standard;WorldNormal;LightDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1.79;False;3;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;227;-1631.374,1361.726;Inherit;False;InstancedProperty;_ShadowBias;ShadowBias;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;280;-1338,1180.738;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1803.617,477.8854;Inherit;False;InstancedProperty;_ShadowSize;ShadowSize;5;0;Create;True;0;0;0;False;0;False;1.43935;0.588;0.5;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1678.384,898.7499;Inherit;False;InstancedProperty;_LightSize;LightSize;6;0;Create;True;0;0;0;False;0;False;1.12274;0.871;0.5;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;14;-404.9291,-624.4144;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;13;-564.2043,-644.4221;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-232.5139,-456.1873;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-529.1033,-336.9012;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;43.99643,-427.024;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;299;382.8456,-421.6346;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;31;777.7137,-81.29669;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;296;1595.067,-2.074378;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;289;1286.828,-823.217;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;293;979.9839,-584.329;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;294;1751.047,-1000.147;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;297;2124.626,-988.3204;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;292;1331.436,-205.6971;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;291;1081.795,-229.9926;Inherit;False;142;ShadowShape;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;290;757.918,-428.7042;Inherit;False;231;LightShape;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;298;2378.071,-573.7149;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;65;-1002.816,-347.331;Inherit;True;Standard;WorldNormal;LightDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;1;-820.0136,-679.1107;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;118;2979.833,-517.9363;Inherit;True;Lighting;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;301;2684.771,-446.7944;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;4269.831,-161.9836;Inherit;True;118;Lighting;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;83;-474.1044,989.8578;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;303;-699.4754,1007.67;Inherit;False;InstancedProperty;_ShadowTilling;ShadowTilling;9;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;42;5421.895,74.77202;Inherit;True;Property;_LEDsShape;LEDsShape;8;0;Create;True;0;0;0;False;0;False;-1;35d13201fe22b254a9f23500199a21b5;ace3fde22b8b0ce409ea785cf7cc2de7;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;1;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RGBToHSVNode;307;4652.235,403.1471;Inherit;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;29;392.0363,-180.9975;Inherit;False;InstancedProperty;_ShadowStrenght;ShadowStrenght;1;0;Create;True;0;0;0;False;0;False;0.596083;0.536;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;319;4670.765,304.5936;Inherit;False;InstancedProperty;_Preset;Preset;10;0;Create;True;0;0;0;False;0;False;0;0.75;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;6763.288,-7.457466;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;MainShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;6435.806,83.63902;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;5904.44,162.8525;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;48;6098.03,-158.8896;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;312;4997.175,362.9471;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;41;4424.404,214.6959;Inherit;False;InstancedProperty;_BaseColor;Base Color;4;0;Create;True;0;0;0;False;0;False;1,0.2399642,0,0;0.2639146,0.2159525,0.3836476,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;45;5530.012,503.2668;Inherit;False;InstancedProperty;_LEDsColor;LEDs Color;3;0;Create;True;0;0;0;False;0;False;0.9707701,1,0,0;1,0.4166667,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.HSVToRGBNode;311;5305.975,422.0135;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;314;-996.6096,933.0947;Inherit;True;Dots Pattern;-1;;14;7d8d5e315fd9002418fb41741d3a59cb;1,22,0;5;21;FLOAT2;0,0;False;3;FLOAT2;48,48;False;2;FLOAT;0.9;False;4;FLOAT;0.5;False;5;FLOAT;0.5;False;1;FLOAT;0
WireConnection;39;0;117;0
WireConnection;39;1;41;0
WireConnection;98;0;87;0
WireConnection;98;1;35;1
WireConnection;82;0;81;0
WireConnection;82;1;35;1
WireConnection;35;1;83;0
WireConnection;136;0;135;0
WireConnection;99;1;100;0
WireConnection;105;1;104;0
WireConnection;44;0;39;0
WireConnection;44;1;42;0
WireConnection;104;0;98;0
WireConnection;100;0;82;0
WireConnection;234;0;99;0
WireConnection;235;0;105;0
WireConnection;241;0;235;0
WireConnection;236;0;234;0
WireConnection;242;0;40;0
WireConnection;231;0;241;0
WireConnection;142;0;236;0
WireConnection;237;0;40;0
WireConnection;87;2;72;0
WireConnection;132;0;134;0
WireConnection;286;0;284;0
WireConnection;286;1;261;0
WireConnection;134;4;286;0
WireConnection;134;1;227;0
WireConnection;134;2;255;0
WireConnection;81;2;80;0
WireConnection;255;0;23;0
WireConnection;80;1;132;0
WireConnection;72;0;136;0
WireConnection;135;1;227;0
WireConnection;135;2;280;0
WireConnection;280;0;25;0
WireConnection;14;2;13;1
WireConnection;13;0;1;0
WireConnection;17;1;11;0
WireConnection;11;0;65;0
WireConnection;18;0;17;0
WireConnection;299;0;18;0
WireConnection;31;0;29;0
WireConnection;296;0;292;0
WireConnection;296;2;31;0
WireConnection;289;0;299;0
WireConnection;289;1;293;0
WireConnection;293;0;290;0
WireConnection;294;0;289;0
WireConnection;294;1;292;0
WireConnection;297;0;294;0
WireConnection;297;2;29;0
WireConnection;292;0;291;0
WireConnection;298;0;297;0
WireConnection;298;1;293;0
WireConnection;298;2;296;0
WireConnection;118;0;301;0
WireConnection;301;0;298;0
WireConnection;83;0;303;0
WireConnection;307;0;41;0
WireConnection;0;2;47;0
WireConnection;47;0;48;0
WireConnection;47;1;43;0
WireConnection;43;0;42;0
WireConnection;43;1;311;0
WireConnection;48;0;44;0
WireConnection;312;0;319;0
WireConnection;312;1;307;1
WireConnection;311;0;312;0
ASEEND*/
//CHKSM=0D7B348E11F0777E467CC8EA35135F4440442F87