// Upgrade NOTE: upgraded instancing buffer 'PowerUp' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PowerUp"
{
	Properties
	{
		_PusleColor("PusleColor", Color) = (0.01673412,0,1,0)
		_ColorBack("ColorBack", Color) = (1,0,0,0)
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

		UNITY_INSTANCING_BUFFER_START(PowerUp)
			UNITY_DEFINE_INSTANCED_PROP(float4, _ColorBack)
#define _ColorBack_arr PowerUp
			UNITY_DEFINE_INSTANCED_PROP(float4, _PusleColor)
#define _PusleColor_arr PowerUp
		UNITY_INSTANCING_BUFFER_END(PowerUp)


		float2 voronoihash1( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi1( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -3; j <= 3; j++ )
			{
				for ( int i = -3; i <= 3; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash1( n + g );
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
			return F1;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 _ColorBack_Instance = UNITY_ACCESS_INSTANCED_PROP(_ColorBack_arr, _ColorBack);
			float4 _PusleColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_PusleColor_arr, _PusleColor);
			float4 blendOpSrc8 = _ColorBack_Instance;
			float4 blendOpDest8 = _PusleColor_Instance;
			float time1 = ( _CosTime.z * 20.0 );
			float2 voronoiSmoothId1 = 0;
			float2 uv_TexCoord5 = i.uv_texcoord * float2( 4,4 );
			float2 coords1 = uv_TexCoord5 * 1.0;
			float2 id1 = 0;
			float2 uv1 = 0;
			float fade1 = 0.5;
			float voroi1 = 0;
			float rest1 = 0;
			for( int it1 = 0; it1 <2; it1++ ){
			voroi1 += fade1 * voronoi1( coords1, time1, id1, uv1, 0,voronoiSmoothId1 );
			rest1 += fade1;
			coords1 *= 2;
			fade1 *= 0.5;
			}//Voronoi1
			voroi1 /= rest1;
			float4 lerpBlendMode8 = lerp(blendOpDest8,(( blendOpSrc8 > 0.5 )? ( blendOpDest8 + 2.0 * blendOpSrc8 - 1.0 ) : ( blendOpDest8 + 2.0 * ( blendOpSrc8 - 0.5 ) ) ),voroi1);
			o.Emission = ( saturate( lerpBlendMode8 )).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.CosTime;4;-611.3333,-250.3332;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-388,-254.3332;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;558,-486.6667;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;PowerUp;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.BlendOpsNode;8;228.6666,-413.6664;Inherit;True;LinearLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-438,-424.9998;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;4,4;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;1;-155.3334,-315.6665;Inherit;True;2;0;1;0;2;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.ColorNode;7;-172.6667,-705.6666;Inherit;False;InstancedProperty;_ColorBack;ColorBack;1;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;9;-177.6,-520.3331;Inherit;False;InstancedProperty;_PusleColor;PusleColor;0;0;Create;True;0;0;0;False;0;False;0.01673412,0,1,0;0.01673412,0,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;3;0;4;3
WireConnection;0;2;8;0
WireConnection;8;0;7;0
WireConnection;8;1;9;0
WireConnection;8;2;1;0
WireConnection;1;0;5;0
WireConnection;1;1;3;0
ASEEND*/
//CHKSM=245CB5F4324EE295B6E50892C126CD7E6E5D1E4E