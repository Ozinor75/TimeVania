// Upgrade NOTE: upgraded instancing buffer 'ForceField' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ForceField"
{
	Properties
	{
		_Color("Color", Color) = (0.3529412,0.3529412,1,1)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TimeScale("TimeScale", Float) = 1
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
		#pragma multi_compile_instancing
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color;
		uniform sampler2D _TextureSample0;

		UNITY_INSTANCING_BUFFER_START(ForceField)
			UNITY_DEFINE_INSTANCED_PROP(float, _TimeScale)
#define _TimeScale_arr ForceField
		UNITY_INSTANCING_BUFFER_END(ForceField)


		float2 voronoihash28( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi28( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash28( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return (F2 + F1) * 0.5;
		}


		float2 voronoihash30( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi30( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash30( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = max(abs(r.x), abs(r.y));
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return (F2 + F1) * 0.5;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float _TimeScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_TimeScale_arr, _TimeScale);
			float mulTime24 = _Time.y * _TimeScale_Instance;
			float time28 = ( mulTime24 * -1.0 );
			float2 voronoiSmoothId28 = 0;
			float2 uv_TexCoord13 = i.uv_texcoord * float2( 1,0.02 ) + float2( -0.4,0 );
			float2 coords28 = uv_TexCoord13 * 8.0;
			float2 id28 = 0;
			float2 uv28 = 0;
			float voroi28 = voronoi28( coords28, time28, id28, uv28, 0, voronoiSmoothId28 );
			float smoothstepResult29 = smoothstep( 0.15 , -0.11 , voroi28);
			float lerpResult10 = lerp( 1.0 , 16.0 , ( mulTime24 * 0.2 ));
			float time30 = lerpResult10;
			float2 voronoiSmoothId30 = 0;
			float2 coords30 = uv_TexCoord13 * 8.0;
			float2 id30 = 0;
			float2 uv30 = 0;
			float voroi30 = voronoi30( coords30, time30, id30, uv30, 0, voronoiSmoothId30 );
			float smoothstepResult31 = smoothstep( 6.47 , -0.04 , voroi30);
			float lerpResult33 = lerp( smoothstepResult29 , smoothstepResult31 , voroi28);
			float smoothstepResult23 = smoothstep( -1.0 , 3.0 , lerpResult33);
			o.Emission = ( _Color * ( smoothstepResult23 + tex2D( _TextureSample0, uv_TexCoord13 ).r ) ).rgb;
			o.Alpha = lerpResult33;
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
Node;AmplifyShaderEditor.SmoothstepOpNode;31;-357.0668,-458.1144;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;6.47;False;2;FLOAT;-0.04;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;30;-555.1119,-459.2237;Inherit;False;0;3;1;3;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;8;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.VoronoiNode;28;-559.4097,-328.0852;Inherit;False;0;0;1;3;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;8;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SmoothstepOpNode;29;-361.0667,-327.2791;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.15;False;2;FLOAT;-0.11;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;40;-361.259,-206.371;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;f80c56b9c5d2bee478895c97dd3b0f7b;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;27.54198,-450.6572;Inherit;False;Property;_Color;Color;0;0;Create;True;0;0;0;False;0;False;0.3529412,0.3529412,1,1;0.3529412,0.3529412,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;33;-158.5594,-457.787;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.52;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;23;33.38234,-277.0534;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;212.959,-275.6486;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;425.7368,-439.2274;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;6;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;638.0219,-431.3437;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ForceField;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-896.3127,-172.0422;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,0.02;False;1;FLOAT2;-0.4,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-833.4089,-285.2636;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;10;-825.667,-462.3334;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;16;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1003.667,-439.3334;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;24;-1223.991,-284.2687;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1395.622,-288.4525;Inherit;False;InstancedProperty;_TimeScale;TimeScale;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
WireConnection;31;0;30;0
WireConnection;30;0;13;0
WireConnection;30;1;10;0
WireConnection;28;0;13;0
WireConnection;28;1;20;0
WireConnection;29;0;28;0
WireConnection;40;1;13;0
WireConnection;33;0;29;0
WireConnection;33;1;31;0
WireConnection;33;2;28;0
WireConnection;23;0;33;0
WireConnection;41;0;23;0
WireConnection;41;1;40;1
WireConnection;21;0;3;0
WireConnection;21;1;41;0
WireConnection;0;2;21;0
WireConnection;0;9;33;0
WireConnection;20;0;24;0
WireConnection;10;2;8;0
WireConnection;8;0;24;0
WireConnection;24;0;42;0
ASEEND*/
//CHKSM=DE27C28964E7F7FA174E3D8CC850E6BF3D9F6E8E