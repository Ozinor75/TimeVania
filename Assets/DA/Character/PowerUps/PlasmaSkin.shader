// Upgrade NOTE: upgraded instancing buffer 'Plasma' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Plasma"
{
	Properties
	{
		_BeamColor("BeamColor", Color) = (0.5531816,0,1,1)
		_SoftColor("SoftColor", Color) = (0,0,1,1)
		_TimeScale("TimeScale", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
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

		UNITY_INSTANCING_BUFFER_START(Plasma)
			UNITY_DEFINE_INSTANCED_PROP(float, _TimeScale)
#define _TimeScale_arr Plasma
		UNITY_INSTANCING_BUFFER_END(Plasma)


		float2 voronoihash78( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi78( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash78( n + g );
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
			float4 blendOpSrc75 = _BeamColor;
			float4 blendOpDest75 = _SoftColor;
			float _TimeScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_TimeScale_arr, _TimeScale);
			float mulTime81 = _Time.y * _TimeScale_Instance;
			float time78 = ( mulTime81 * 1.0 );
			float2 voronoiSmoothId78 = 0;
			float2 appendResult82 = (float2(( mulTime81 * 0.5 ) , ( mulTime81 * 0.2 )));
			float2 uv_TexCoord79 = i.uv_texcoord + appendResult82;
			float2 coords78 = uv_TexCoord79 * 6.0;
			float2 id78 = 0;
			float2 uv78 = 0;
			float fade78 = 0.5;
			float voroi78 = 0;
			float rest78 = 0;
			for( int it78 = 0; it78 <3; it78++ ){
			voroi78 += fade78 * voronoi78( coords78, time78, id78, uv78, 0,voronoiSmoothId78 );
			rest78 += fade78;
			coords78 *= 2;
			fade78 *= 0.5;
			}//Voronoi78
			voroi78 /= rest78;
			float smoothstepResult80 = smoothstep( -0.08 , 0.84 , voroi78);
			float clampResult87 = clamp( step( voroi78 , 0.22 ) , 0.4 , 1.0 );
			float4 lerpBlendMode75 = lerp(blendOpDest75,(( blendOpSrc75 > 0.5 )? ( blendOpDest75 + 2.0 * blendOpSrc75 - 1.0 ) : ( blendOpDest75 + 2.0 * ( blendOpSrc75 - 0.5 ) ) ),( smoothstepResult80 * clampResult87 ));
			float4 break76 = ( saturate( lerpBlendMode75 ));
			float2 appendResult10_g1 = (float2(1.0 , 1.0));
			float2 temp_output_11_0_g1 = ( abs( (i.uv_texcoord*2.0 + -1.0) ) - appendResult10_g1 );
			float2 break16_g1 = ( 1.0 - ( temp_output_11_0_g1 / fwidth( temp_output_11_0_g1 ) ) );
			float temp_output_63_0 = saturate( min( break16_g1.x , break16_g1.y ) );
			float4 appendResult46 = (float4(break76.r , break76.g , break76.b , temp_output_63_0));
			float4 blendOpSrc62 = appendResult46;
			float4 blendOpDest62 = float4( 0,0,0,0 );
			o.Emission = ( ( saturate( 	max( blendOpSrc62, blendOpDest62 ) )) + ( appendResult46 * temp_output_63_0 ) ).xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-772.4195,-429.3848;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-767.8447,-532.864;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;79;-431.0895,-460.1681;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-365.8848,-337.4075;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;80;6.810593,-466.768;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.08;False;2;FLOAT;0.84;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;85;13.25797,-244.145;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.22;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;87;234.9444,-251.7531;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.4;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;495.5751,-467.6005;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;75;738.7468,-472.39;Inherit;True;LinearLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;64;738.6636,-250.3116;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;76;1005.021,-471.2881;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FunctionNode;63;965.336,-252.5418;Inherit;False;Rectangle;-1;;1;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;46;1172.09,-472.5591;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BlendOpsNode;62;1428.317,-473.1392;Inherit;True;Lighten;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;1429.91,-248.5925;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;1685.969,-470.7086;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;20;1900.195,-468.5442;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Plasma;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleTimeNode;81;-1026.131,-338.026;Inherit;False;1;0;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;82;-590.2981,-436.1371;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;38;487.5735,-635.6727;Inherit;False;Property;_SoftColor;SoftColor;1;0;Create;True;0;0;0;False;0;False;0,0,1,1;0.5019608,0,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;40;487.3776,-805.9418;Inherit;False;Property;_BeamColor;BeamColor;0;0;Create;True;0;0;0;False;0;False;0.5531816,0,1,1;0,0,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;78;-200.7895,-366.0347;Inherit;False;0;0;1;3;3;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;6;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;88;-1191.417,-348.5569;Inherit;False;InstancedProperty;_TimeScale;TimeScale;2;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
WireConnection;84;0;81;0
WireConnection;83;0;81;0
WireConnection;79;1;82;0
WireConnection;77;0;81;0
WireConnection;80;0;78;0
WireConnection;85;0;78;0
WireConnection;87;0;85;0
WireConnection;86;0;80;0
WireConnection;86;1;87;0
WireConnection;75;0;40;0
WireConnection;75;1;38;0
WireConnection;75;2;86;0
WireConnection;76;0;75;0
WireConnection;63;1;64;0
WireConnection;46;0;76;0
WireConnection;46;1;76;1
WireConnection;46;2;76;2
WireConnection;46;3;63;0
WireConnection;62;0;46;0
WireConnection;73;0;46;0
WireConnection;73;1;63;0
WireConnection;42;0;62;0
WireConnection;42;1;73;0
WireConnection;20;2;42;0
WireConnection;81;0;88;0
WireConnection;82;0;83;0
WireConnection;82;1;84;0
WireConnection;78;0;79;0
WireConnection;78;1;77;0
ASEEND*/
//CHKSM=6ED0B11CD9A2D973F06951B5C5208B131266105B