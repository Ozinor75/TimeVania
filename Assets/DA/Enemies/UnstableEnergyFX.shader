// Upgrade NOTE: upgraded instancing buffer 'EnergyFX' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EnergyFX"
{
	Properties
	{
		_UnstableBoltFX("UnstableBoltFX", 2D) = "white" {}
		_StableBoltFX("StableBoltFX", 2D) = "white" {}
		[HDR]_BoltColor("BoltColor", Color) = (1,0,0,1)
		[HideInInspector]_TimeScale("TimeScale", Float) = 0
		_BaseSpeed("BaseSpeed", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _UnstableBoltFX;
		uniform float _BaseSpeed;
		uniform sampler2D _StableBoltFX;
		uniform float4 _BoltColor;

		UNITY_INSTANCING_BUFFER_START(EnergyFX)
			UNITY_DEFINE_INSTANCED_PROP(float, _TimeScale)
#define _TimeScale_arr EnergyFX
		UNITY_INSTANCING_BUFFER_END(EnergyFX)

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float _TimeScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_TimeScale_arr, _TimeScale);
			float mulTime7 = _Time.y * _TimeScale_Instance;
			float temp_output_5_0 = ( mulTime7 * 3.0 * _BaseSpeed );
			float temp_output_10_0 = ( mulTime7 * 1.0 * _BaseSpeed );
			float2 appendResult14 = (float2(temp_output_5_0 , temp_output_10_0));
			float2 uv_TexCoord13 = i.uv_texcoord + appendResult14;
			float2 appendResult15 = (float2(temp_output_5_0 , temp_output_10_0));
			float2 uv_TexCoord19 = i.uv_texcoord + appendResult15;
			float4 temp_output_16_0 = ( ( ( tex2D( _UnstableBoltFX, uv_TexCoord13 ).r * 1.0 ) + ( tex2D( _StableBoltFX, uv_TexCoord19 ).r * 1.0 ) ) * _BoltColor );
			o.Emission = temp_output_16_0.rgb;
			o.Alpha = temp_output_16_0.r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
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
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
Version=19200
Node;AmplifyShaderEditor.SamplerNode;8;-1462.069,-315.3369;Inherit;True;Property;_UnstableBoltFX;UnstableBoltFX;0;0;Create;True;0;0;0;False;0;False;-1;688a57e387def8f4197eeeae84564b86;688a57e387def8f4197eeeae84564b86;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;11;-1459.502,-90.16734;Inherit;True;Property;_StableBoltFX;StableBoltFX;1;0;Create;True;0;0;0;False;0;False;-1;None;7a170cdb7cc88024cb628cfcdbb6705c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;14;-1827.033,-265.2095;Inherit;False;FLOAT2;4;0;FLOAT;0.95;False;1;FLOAT;0.02;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1994.891,-250.5563;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;3;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1999.071,-70.51034;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;7;-2198.848,-38.87268;Inherit;False;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-962.5995,-312.1111;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;-969.9434,-78.19241;Inherit;False;Property;_BoltColor;BoltColor;2;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-722.7418,-314.3923;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;2;-486.8217,-310.8983;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;EnergyFX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-1177.164,-314.3072;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1178.082,-87.93687;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;-1816.514,-65.2542;Inherit;False;FLOAT2;4;0;FLOAT;0.73;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-1668.391,-88.82159;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-1674.895,-306.2641;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;-2367.963,-37.381;Inherit;False;InstancedProperty;_TimeScale;TimeScale;3;1;[HideInInspector];Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-2289.767,-214.8518;Inherit;False;Property;_BaseSpeed;BaseSpeed;4;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
WireConnection;8;1;13;0
WireConnection;11;1;19;0
WireConnection;14;0;5;0
WireConnection;14;1;10;0
WireConnection;5;0;7;0
WireConnection;5;2;27;0
WireConnection;10;0;7;0
WireConnection;10;2;27;0
WireConnection;7;0;26;0
WireConnection;3;0;4;0
WireConnection;3;1;6;0
WireConnection;16;0;3;0
WireConnection;16;1;17;0
WireConnection;2;2;16;0
WireConnection;2;9;16;0
WireConnection;4;0;8;1
WireConnection;6;0;11;1
WireConnection;15;0;5;0
WireConnection;15;1;10;0
WireConnection;19;1;15;0
WireConnection;13;1;14;0
ASEEND*/
//CHKSM=EC0E11624A7D7F8222A8F8F31C6C7C30F66C4739