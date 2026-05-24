// Upgrade NOTE: upgraded instancing buffer 'StableBoltFX' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "StableBoltFX"
{
	Properties
	{
		_Bolt1("Bolt1", 2D) = "white" {}
		_Bolt2("Bolt2", 2D) = "white" {}
		[HDR]_BoltColor("BoltColor", Color) = (0,0,0,0)
		_TimeScale("TimeScale", Float) = 0
		_GlobalSpeed("GlobalSpeed", Float) = 0
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

		uniform float4 _BoltColor;
		uniform sampler2D _Bolt1;
		uniform float _GlobalSpeed;
		uniform sampler2D _Bolt2;

		UNITY_INSTANCING_BUFFER_START(StableBoltFX)
			UNITY_DEFINE_INSTANCED_PROP(float, _TimeScale)
#define _TimeScale_arr StableBoltFX
		UNITY_INSTANCING_BUFFER_END(StableBoltFX)

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float _TimeScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_TimeScale_arr, _TimeScale);
			float mulTime42 = _Time.y * _TimeScale_Instance;
			float temp_output_67_0 = ( mulTime42 * 0.2 * _GlobalSpeed );
			float temp_output_34_0 = ( mulTime42 * 1.0 * _GlobalSpeed );
			float2 appendResult55 = (float2(temp_output_67_0 , temp_output_34_0));
			float2 uv_TexCoord39 = i.uv_texcoord * float2( 1,0.5 ) + appendResult55;
			float2 appendResult56 = (float2(temp_output_67_0 , temp_output_34_0));
			float2 uv_TexCoord37 = i.uv_texcoord * float2( 1,0.5 ) + appendResult56;
			float2 appendResult62 = (float2(uv_TexCoord37.y , uv_TexCoord37.x));
			float temp_output_30_0 = ( ( tex2D( _Bolt1, uv_TexCoord39 ).r * 1.0 ) + ( tex2D( _Bolt2, appendResult62 ).r * 1.0 ) );
			o.Emission = ( _BoltColor * temp_output_30_0 ).rgb;
			o.Alpha = temp_output_30_0;
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
Node;AmplifyShaderEditor.SamplerNode;38;-125.837,260.012;Inherit;True;Property;_Bolt1;Bolt1;0;0;Create;True;0;0;0;False;0;False;-1;688a57e387def8f4197eeeae84564b86;4de9a4d940105f44497e1aa05ee52c8e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;639.3112,333.0849;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;63;367.3783,140.776;Inherit;False;Property;_BoltColor;BoltColor;2;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;1.052283,11.03091,7.220452,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;936.5251,315.0321;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;StableBoltFX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleTimeNode;42;-1107.513,449.9134;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-1268.505,448.3853;Inherit;False;InstancedProperty;_TimeScale;TimeScale;3;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-1267.681,527.5123;Inherit;False;Property;_GlobalSpeed;GlobalSpeed;4;0;Create;True;0;0;0;False;0;False;0;1.618;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;-134.7701,475.3811;Inherit;True;Property;_Bolt2;Bolt2;1;0;Create;True;0;0;0;False;0;False;-1;942d27e6ad5150040bb5f55937b8ff7c;7a170cdb7cc88024cb628cfcdbb6705c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;56;-677.0702,548.2991;Inherit;False;FLOAT2;4;0;FLOAT;0.44;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;405.0944,369.7924;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-892.4691,533.0808;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-875.203,257.2452;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;55;-681.8544,284.2846;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;62;-296.0188,537.8622;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;184.15,476.412;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;172.1829,266.9261;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-506.745,315.3207;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-512.2043,520.5789;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,0.5;False;1;FLOAT2;0,0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;38;1;39;0
WireConnection;45;0;63;0
WireConnection;45;1;30;0
WireConnection;0;2;45;0
WireConnection;0;9;30;0
WireConnection;42;0;65;0
WireConnection;36;1;62;0
WireConnection;56;0;67;0
WireConnection;56;1;34;0
WireConnection;30;0;64;0
WireConnection;30;1;32;0
WireConnection;34;0;42;0
WireConnection;34;2;66;0
WireConnection;67;0;42;0
WireConnection;67;2;66;0
WireConnection;55;0;67;0
WireConnection;55;1;34;0
WireConnection;62;0;37;2
WireConnection;62;1;37;1
WireConnection;32;0;36;1
WireConnection;64;0;38;1
WireConnection;39;1;55;0
WireConnection;37;1;56;0
ASEEND*/
//CHKSM=565B8B53F33C03F20A5F490459861189A2C961B5