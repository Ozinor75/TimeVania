// Upgrade NOTE: upgraded instancing buffer 'BaseShader' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BaseShader"
{
	Properties
	{
		_ShadowStrenght("ShadowStrenght", Range( 0 , 1)) = 0.5607273
		[HDR]_LEDsColor("LEDs Color", Color) = (0.9707701,1,0,0)
		_BaseColor("Base Color", Color) = (1,0.2399642,0,0)
		_ShadowSize("ShadowSize", Range( 0.5 , 1)) = 1
		_LightSize("LightSize", Range( 0.5 , 1)) = 0.7448979
		_LEDsShape("LEDsShape", 2D) = "black" {}
		_Preset("Preset", Range( 0 , 1)) = 0
		_UseCustomColor("Use Custom Color", Int) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Roughness("Roughness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
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

		uniform sampler2D _LEDsShape;
		uniform int _UseCustomColor;
		uniform float4 _LEDsColor;
		uniform float _Metallic;
		uniform float _Roughness;

		UNITY_INSTANCING_BUFFER_START(BaseShader)
			UNITY_DEFINE_INSTANCED_PROP(float4, _BaseColor)
#define _BaseColor_arr BaseShader
			UNITY_DEFINE_INSTANCED_PROP(float4, _LEDsShape_ST)
#define _LEDsShape_ST_arr BaseShader
			UNITY_DEFINE_INSTANCED_PROP(float, _LightSize)
#define _LightSize_arr BaseShader
			UNITY_DEFINE_INSTANCED_PROP(float, _ShadowStrenght)
#define _ShadowStrenght_arr BaseShader
			UNITY_DEFINE_INSTANCED_PROP(float, _ShadowSize)
#define _ShadowSize_arr BaseShader
			UNITY_DEFINE_INSTANCED_PROP(float, _Preset)
#define _Preset_arr BaseShader
		UNITY_INSTANCING_BUFFER_END(BaseShader)


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

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV65 = dot( ase_worldNormal, ase_worldlightDir );
			float fresnelNode65 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV65, 1.0 ) );
			float _LightSize_Instance = UNITY_ACCESS_INSTANCED_PROP(_LightSize_arr, _LightSize);
			float fresnelNdotV323 = dot( ase_worldNormal, ase_worldlightDir );
			float fresnelNode323 = ( 0.0 + _LightSize_Instance * pow( 1.0 - fresnelNdotV323, 1.0 ) );
			float NormalSize231 = step( 0.0 , ( 1.0 - fresnelNode323 ) );
			float _ShadowStrenght_Instance = UNITY_ACCESS_INSTANCED_PROP(_ShadowStrenght_arr, _ShadowStrenght);
			float clampResult296 = clamp( NormalSize231 , 0.0 , ( _ShadowStrenght_Instance / 2.0 ) );
			float _ShadowSize_Instance = UNITY_ACCESS_INSTANCED_PROP(_ShadowSize_arr, _ShadowSize);
			float fresnelNdotV135 = dot( ase_worldNormal, ase_worldlightDir );
			float fresnelNode135 = ( 0.0 + _ShadowSize_Instance * pow( 1.0 - fresnelNdotV135, 1.0 ) );
			float ShadowSize142 = step( ( 1.0 - fresnelNode135 ) , 0.0 );
			float clampResult297 = clamp( ShadowSize142 , 0.0 , _ShadowStrenght_Instance );
			float Lighting118 = ( ( step( ( ( 0.0 + ( fresnelNode65 * 0.5 ) ) + 0.5 ) , 2.0 ) - clampResult296 ) - clampResult297 );
			float4 _BaseColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_BaseColor_arr, _BaseColor);
			float4 temp_output_39_0 = ( Lighting118 * _BaseColor_Instance );
			o.Albedo = temp_output_39_0.rgb;
			float4 _LEDsShape_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_LEDsShape_ST_arr, _LEDsShape_ST);
			float2 uv_LEDsShape = i.uv_texcoord * _LEDsShape_ST_Instance.xy + _LEDsShape_ST_Instance.zw;
			float4 tex2DNode42 = tex2D( _LEDsShape, uv_LEDsShape );
			float _Preset_Instance = UNITY_ACCESS_INSTANCED_PROP(_Preset_arr, _Preset);
			float3 hsvTorgb307 = RGBToHSV( _BaseColor_Instance.rgb );
			float3 hsvTorgb311 = HSVToRGB( float3(( _Preset_Instance + hsvTorgb307.x ),1.0,1.0) );
			float4 temp_output_43_0 = ( tex2DNode42 * ( (float)_UseCustomColor == 0.0 ? float4( hsvTorgb311 , 0.0 ) : _LEDsColor ) );
			o.Emission = temp_output_43_0.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = ( _Roughness * -1.0 );
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
Node;AmplifyShaderEditor.DynamicAppendNode;348;2837.025,740.6566;Inherit;False;FLOAT3;4;0;FLOAT;-1;False;1;FLOAT;1;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;357;2600.17,689.0459;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;358;2597.17,784.0459;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;359;2586.17,889.0457;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;328;3408.932,585.147;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;326;3568.313,593.1063;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;142;3704.539,597.5516;Inherit;True;ShadowSize;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;323;3095.732,233.8104;Inherit;False;Standard;WorldNormal;LightDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;132;3398.176,232.6472;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;325;3550.489,241.4348;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;231;3696.45,247.8241;Inherit;True;NormalSize;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;135;3107.911,585.8651;Inherit;False;Standard;WorldNormal;LightDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1.79;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;2483.003,255.5651;Inherit;False;InstancedProperty;_LightSize;LightSize;4;0;Create;True;0;0;0;False;0;False;0.7448979;0.671;0.5;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;2488.197,347.3731;Inherit;False;InstancedProperty;_ShadowSize;ShadowSize;3;0;Create;True;0;0;0;False;0;False;1;0.698;0.5;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;319;4749.402,248.9429;Inherit;False;InstancedProperty;_Preset;Preset;6;0;Create;True;0;0;0;False;0;False;0;0.648;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;307;4755.068,369.2725;Inherit;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;41;4429.244,203.8077;Inherit;False;InstancedProperty;_BaseColor;Base Color;2;0;Create;True;0;0;0;False;0;False;1,0.2399642,0,0;0.4552941,0.5058824,0.4552941,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;312;5080.65,250.4359;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;311;5227.339,249.3628;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;45;5229.984,426.8633;Inherit;False;Property;_LEDsColor;LEDs Color;1;1;[HDR];Create;True;0;0;0;False;0;False;0.9707701,1,0,0;1,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Compare;320;5540.13,319.34;Inherit;False;0;4;0;INT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;322;5233.732,162.8508;Inherit;False;Property;_UseCustomColor;Use Custom Color;7;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;5817.92,144.7958;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;42;5234.531,-41.02565;Inherit;True;Property;_LEDsShape;LEDsShape;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;1;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;339;3463.84,-9.538287;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;2498.613,32.21843;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;2685.337,32.63646;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;2832.304,40.4826;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;65;2266.529,36.82652;Inherit;False;Standard;WorldNormal;LightDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;297;2870.729,-434.7963;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;291;2665.158,-437.1064;Inherit;False;142;ShadowSize;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;290;2658.693,-62.71738;Inherit;False;231;NormalSize;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;4449.868,-144.698;Inherit;True;118;Lighting;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;299;2972.739,42.59246;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;296;2871.14,-208.0322;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;338;3223.354,-9.240863;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;118;3714.844,-9.156982;Inherit;True;Lighting;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;367;2679.751,-208.1952;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;2271.953,-311.5937;Inherit;False;InstancedProperty;_ShadowStrenght;ShadowStrenght;0;0;Create;True;0;0;0;False;0;False;0.5607273;0.631;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;5339.82,-271.139;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;44;5804.772,-342.2456;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;48;6048.837,-345.4602;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;6349.243,-289.8532;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;6736.254,46.13136;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;BaseShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;372;6422.844,388.8636;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;368;6247.844,292.8636;Inherit;False;Property;_Metallic;Metallic;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;373;6088.844,399.8636;Inherit;False;Property;_Roughness;Roughness;9;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;345;2251.925,746.7567;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
WireConnection;348;0;357;0
WireConnection;348;1;358;0
WireConnection;348;2;359;0
WireConnection;357;0;345;1
WireConnection;358;0;345;2
WireConnection;359;0;345;3
WireConnection;328;0;135;0
WireConnection;326;0;328;0
WireConnection;142;0;326;0
WireConnection;323;4;345;0
WireConnection;323;2;25;0
WireConnection;132;0;323;0
WireConnection;325;1;132;0
WireConnection;231;0;325;0
WireConnection;135;4;345;0
WireConnection;135;2;23;0
WireConnection;307;0;41;0
WireConnection;312;0;319;0
WireConnection;312;1;307;1
WireConnection;311;0;312;0
WireConnection;320;0;322;0
WireConnection;320;2;311;0
WireConnection;320;3;45;0
WireConnection;43;0;42;0
WireConnection;43;1;320;0
WireConnection;339;0;338;0
WireConnection;339;1;297;0
WireConnection;11;0;65;0
WireConnection;17;1;11;0
WireConnection;18;0;17;0
WireConnection;65;4;345;0
WireConnection;297;0;291;0
WireConnection;297;2;29;0
WireConnection;299;0;18;0
WireConnection;296;0;290;0
WireConnection;296;2;367;0
WireConnection;338;0;299;0
WireConnection;338;1;296;0
WireConnection;118;0;339;0
WireConnection;367;0;29;0
WireConnection;39;0;117;0
WireConnection;39;1;41;0
WireConnection;44;0;39;0
WireConnection;44;1;42;0
WireConnection;48;0;44;0
WireConnection;47;0;48;0
WireConnection;47;1;43;0
WireConnection;0;0;39;0
WireConnection;0;2;43;0
WireConnection;0;3;368;0
WireConnection;0;4;372;0
WireConnection;372;0;373;0
ASEEND*/
//CHKSM=A71CBCF6CB3DF86406D4B53B1B7EF97B1A3CE0BD