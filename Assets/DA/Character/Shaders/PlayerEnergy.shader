// Upgrade NOTE: upgraded instancing buffer 'PlayerEnergy' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PlayerEnergy"
{
	Properties
	{
		_BeamColor("BeamColor", Color) = (0.5531816,0,1,1)
		_SoftColor("SoftColor", Color) = (0,0,1,1)
		_DamageColor("DamageColor", Color) = (0,0,1,1)
		_TimeScale("TimeScale", Float) = 0
		_ConsuptionSpeed("ConsuptionSpeed", Float) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_DamageT("DamageT", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _BeamColor;
		uniform float4 _SoftColor;
		uniform float4 _DamageColor;
		uniform sampler2D _TextureSample0;

		UNITY_INSTANCING_BUFFER_START(PlayerEnergy)
			UNITY_DEFINE_INSTANCED_PROP(float, _DamageT)
#define _DamageT_arr PlayerEnergy
			UNITY_DEFINE_INSTANCED_PROP(float, _TimeScale)
#define _TimeScale_arr PlayerEnergy
			UNITY_DEFINE_INSTANCED_PROP(float, _ConsuptionSpeed)
#define _ConsuptionSpeed_arr PlayerEnergy
		UNITY_INSTANCING_BUFFER_END(PlayerEnergy)


		float2 voronoihash21( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi21( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash21( n + g );
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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float _DamageT_Instance = UNITY_ACCESS_INSTANCED_PROP(_DamageT_arr, _DamageT);
			float4 blendOpSrc9 = _BeamColor;
			float4 blendOpDest9 = ( _DamageT_Instance == 0.0 ? _SoftColor : _DamageColor );
			float _TimeScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_TimeScale_arr, _TimeScale);
			float mulTime17 = _Time.y * _TimeScale_Instance;
			float time21 = ( mulTime17 * 1.0 );
			float2 voronoiSmoothId21 = 0;
			float2 appendResult18 = (float2(( mulTime17 * 0.5 ) , ( mulTime17 * 0.2 )));
			float2 uv_TexCoord3 = i.uv_texcoord + appendResult18;
			float2 coords21 = uv_TexCoord3 * 6.0;
			float2 id21 = 0;
			float2 uv21 = 0;
			float fade21 = 0.5;
			float voroi21 = 0;
			float rest21 = 0;
			for( int it21 = 0; it21 <3; it21++ ){
			voroi21 += fade21 * voronoi21( coords21, time21, id21, uv21, 0,voronoiSmoothId21 );
			rest21 += fade21;
			coords21 *= 2;
			fade21 *= 0.5;
			}//Voronoi21
			voroi21 /= rest21;
			float smoothstepResult5 = smoothstep( -0.08 , 0.84 , voroi21);
			float clampResult7 = clamp( step( voroi21 , 0.22 ) , 0.4 , 1.0 );
			float4 lerpBlendMode9 = lerp(blendOpDest9,(( blendOpSrc9 > 0.5 )? ( blendOpDest9 + 2.0 * blendOpSrc9 - 1.0 ) : ( blendOpDest9 + 2.0 * ( blendOpSrc9 - 0.5 ) ) ),( smoothstepResult5 * clampResult7 ));
			float4 break11 = ( saturate( lerpBlendMode9 ));
			float2 appendResult10_g1 = (float2(1.0 , 1.0));
			float2 temp_output_11_0_g1 = ( abs( (i.uv_texcoord*2.0 + -1.0) ) - appendResult10_g1 );
			float2 break16_g1 = ( 1.0 - ( temp_output_11_0_g1 / fwidth( temp_output_11_0_g1 ) ) );
			float4 appendResult13 = (float4(break11.r , break11.g , break11.b , saturate( min( break16_g1.x , break16_g1.y ) )));
			float4 blendOpSrc14 = appendResult13;
			float4 blendOpDest14 = float4( 0,0,0,0 );
			float4 temp_output_14_0 = ( saturate( 	max( blendOpSrc14, blendOpDest14 ) ));
			float _ConsuptionSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_ConsuptionSpeed_arr, _ConsuptionSpeed);
			float mulTime31 = _Time.y * _ConsuptionSpeed_Instance;
			float2 appendResult28 = (float2(0.0 , ( mulTime31 * 1.5 )));
			float2 uv_TexCoord26 = i.uv_texcoord + appendResult28;
			o.Emission = ( temp_output_14_0 - ( temp_output_14_0 * tex2D( _TextureSample0, uv_TexCoord26 ) * -5.0 ) ).xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-2713.019,-40.34733;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-2311.059,155.1092;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;5;-1938.364,25.74867;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.08;False;2;FLOAT;0.84;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;6;-1931.917,248.3716;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.22;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;7;-1710.23,240.7635;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.4;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1449.599,24.91619;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;9;-1206.428,20.12667;Inherit;True;LinearLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;11;-940.1532,21.2286;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FunctionNode;12;-979.8381,239.9749;Inherit;False;Rectangle;-1;;1;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-773.0842,19.95757;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.VoronoiNode;21;-2145.964,126.482;Inherit;False;0;0;1;3;3;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;6;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SamplerNode;23;-779.7025,443.0292;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;0;False;0;False;-1;None;05386a8de65066942ab48c279d2128fa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;348,-48;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;PlayerEnergy;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1206.511,242.205;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-2376.264,32.34859;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;-2717.594,63.13187;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-2535.472,56.37958;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;-1322.54,510.3733;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-1103.339,484.5729;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-1536.941,540.3735;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;17;-2971.306,154.4907;Inherit;False;1;0;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-3136.592,143.9598;Inherit;False;InstancedProperty;_TimeScale;TimeScale;3;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;31;-1748.979,553.0902;Inherit;False;1;0;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1982.266,534.5593;Inherit;False;InstancedProperty;_ConsuptionSpeed;ConsuptionSpeed;4;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;-1473.12,-480.8887;Inherit;False;Property;_BeamColor;BeamColor;0;0;Create;True;0;0;0;False;0;False;0.5531816,0,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;14;-501.8571,11.37749;Inherit;True;Lighten;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-70.96826,343.491;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;COLOR;2,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-420.9824,551.8863;Inherit;False;Constant;_Luminance;Luminance;4;0;Create;True;0;0;0;False;0;False;-5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;88.03174,49.49097;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;33;-1739.252,-201.1925;Inherit;False;Property;_DamageColor;DamageColor;2;0;Create;True;0;0;0;False;0;False;0,0,1,1;0.9996002,0.01999198,0.01999198,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;19;-1744.722,-382.6594;Inherit;False;Property;_SoftColor;SoftColor;1;0;Create;True;0;0;0;False;0;False;0,0,1,1;0,0.9,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;36;-1903.505,-316.6379;Inherit;False;InstancedProperty;_DamageT;DamageT;6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;35;-1468.815,-206.4095;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
WireConnection;2;0;17;0
WireConnection;4;0;17;0
WireConnection;5;0;21;0
WireConnection;6;0;21;0
WireConnection;7;0;6;0
WireConnection;8;0;5;0
WireConnection;8;1;7;0
WireConnection;9;0;20;0
WireConnection;9;1;35;0
WireConnection;9;2;8;0
WireConnection;11;0;9;0
WireConnection;12;1;10;0
WireConnection;13;0;11;0
WireConnection;13;1;11;1
WireConnection;13;2;11;2
WireConnection;13;3;12;0
WireConnection;21;0;3;0
WireConnection;21;1;4;0
WireConnection;23;1;26;0
WireConnection;0;2;24;0
WireConnection;3;1;18;0
WireConnection;1;0;17;0
WireConnection;18;0;2;0
WireConnection;18;1;1;0
WireConnection;28;1;27;0
WireConnection;26;1;28;0
WireConnection;27;0;31;0
WireConnection;17;0;22;0
WireConnection;31;0;32;0
WireConnection;14;0;13;0
WireConnection;25;0;14;0
WireConnection;25;1;23;0
WireConnection;25;2;30;0
WireConnection;24;0;14;0
WireConnection;24;1;25;0
WireConnection;35;0;36;0
WireConnection;35;2;19;0
WireConnection;35;3;33;0
ASEEND*/
//CHKSM=0367FF0DAB3AC67151BCCCF386B692BBE80BAAD9