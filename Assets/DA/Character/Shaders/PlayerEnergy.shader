// Upgrade NOTE: upgraded instancing buffer 'PlayerEnergy' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PlayerEnergy"
{
	Properties
	{
		_TimeScale("TimeScale", Float) = 0
		_CSpeed("ConsuptionSpeed", Float) = 0
		[HDR]_TextureSample0("Texture Sample 0", 2D) = "white" {}
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

		uniform sampler2D _TextureSample0;

		UNITY_INSTANCING_BUFFER_START(PlayerEnergy)
			UNITY_DEFINE_INSTANCED_PROP(float, _DamageT)
#define _DamageT_arr PlayerEnergy
			UNITY_DEFINE_INSTANCED_PROP(float, _TimeScale)
#define _TimeScale_arr PlayerEnergy
			UNITY_DEFINE_INSTANCED_PROP(float, _CSpeed)
#define _CSpeed_arr PlayerEnergy
		UNITY_INSTANCING_BUFFER_END(PlayerEnergy)


		struct Gradient
		{
			int type;
			int colorsLength;
			int alphasLength;
			float4 colors[8];
			float2 alphas[8];
		};


		Gradient NewGradient(int type, int colorsLength, int alphasLength, 
		float4 colors0, float4 colors1, float4 colors2, float4 colors3, float4 colors4, float4 colors5, float4 colors6, float4 colors7,
		float2 alphas0, float2 alphas1, float2 alphas2, float2 alphas3, float2 alphas4, float2 alphas5, float2 alphas6, float2 alphas7)
		{
			Gradient g;
			g.type = type;
			g.colorsLength = colorsLength;
			g.alphasLength = alphasLength;
			g.colors[ 0 ] = colors0;
			g.colors[ 1 ] = colors1;
			g.colors[ 2 ] = colors2;
			g.colors[ 3 ] = colors3;
			g.colors[ 4 ] = colors4;
			g.colors[ 5 ] = colors5;
			g.colors[ 6 ] = colors6;
			g.colors[ 7 ] = colors7;
			g.alphas[ 0 ] = alphas0;
			g.alphas[ 1 ] = alphas1;
			g.alphas[ 2 ] = alphas2;
			g.alphas[ 3 ] = alphas3;
			g.alphas[ 4 ] = alphas4;
			g.alphas[ 5 ] = alphas5;
			g.alphas[ 6 ] = alphas6;
			g.alphas[ 7 ] = alphas7;
			return g;
		}


		float4 SampleGradient( Gradient gradient, float time )
		{
			float3 color = gradient.colors[0].rgb;
			UNITY_UNROLL
			for (int c = 1; c < 8; c++)
			{
			float colorPos = saturate((time - gradient.colors[c-1].w) / ( 0.00001 + (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, (float)gradient.colorsLength-1));
			color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
			}
			#ifndef UNITY_COLORSPACE_GAMMA
			color = half3(GammaToLinearSpaceExact(color.r), GammaToLinearSpaceExact(color.g), GammaToLinearSpaceExact(color.b));
			#endif
			float alpha = gradient.alphas[0].x;
			UNITY_UNROLL
			for (int a = 1; a < 8; a++)
			{
			float alphaPos = saturate((time - gradient.alphas[a-1].y) / ( 0.00001 + (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, (float)gradient.alphasLength-1));
			alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
			}
			return float4(color, alpha);
		}


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


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			Gradient gradient45 = NewGradient( 0, 2, 2, float4( 0, 1, 1, 0.5000076 ), float4( 1, 0, 0, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float _DamageT_Instance = UNITY_ACCESS_INSTANCED_PROP(_DamageT_arr, _DamageT);
			float clampResult39 = clamp( _DamageT_Instance , 0.0 , 1.0 );
			float _TimeScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_TimeScale_arr, _TimeScale);
			float mulTime17 = _Time.y * _TimeScale_Instance;
			float time21 = ( mulTime17 * 1.0 );
			float2 voronoiSmoothId21 = 0;
			float2 appendResult18 = (float2(( mulTime17 * 0.5 ) , ( mulTime17 * 0.2 )));
			float2 uv_TexCoord3 = i.uv_texcoord + appendResult18;
			float2 coords21 = uv_TexCoord3 * 12.0;
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
			float4 temp_cast_0 = (( smoothstepResult5 * clampResult7 )).xxxx;
			float _CSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_CSpeed_arr, _CSpeed);
			float mulTime31 = _Time.y * _CSpeed_Instance;
			float2 appendResult28 = (float2(0.0 , ( mulTime31 * 2.0 )));
			float2 uv_TexCoord26 = i.uv_texcoord + appendResult28;
			o.Emission = ( ( SampleGradient( gradient45, clampResult39 ) - CalculateContrast(4.0,temp_cast_0) ) + tex2D( _TextureSample0, uv_TexCoord26 ) ).rgb;
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
Node;AmplifyShaderEditor.StepOpNode;6;-1931.917,248.3716;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.22;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;7;-1710.23,240.7635;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.4;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-2376.264,32.34859;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;-2717.594,63.13187;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-2535.472,56.37958;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;-1322.54,510.3733;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-1103.339,484.5729;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;17;-2971.306,154.4907;Inherit;False;1;0;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-3136.592,143.9598;Inherit;False;InstancedProperty;_TimeScale;TimeScale;0;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;31;-1748.979,553.0902;Inherit;False;1;0;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;5;-1944.364,25.74867;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.08;False;2;FLOAT;0.84;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;39;-1866.866,-104.5838;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-2027.505,-56.63788;Inherit;False;InstancedProperty;_DamageT;DamageT;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;217.6641,30.7168;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;PlayerEnergy;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1467.599,142.9162;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;48;-1310.866,132.9162;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientSampleNode;46;-1663.866,-96.0838;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GradientNode;45;-1929.866,-189.0838;Inherit;False;0;2;2;0,1,1,0.5000076;1,0,0,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-242.1185,161.1294;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-699.9824,601.8863;Inherit;False;Constant;_Luminance;Luminance;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;-839.7025,402.0292;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;1;[HDR];Create;True;0;0;0;False;0;False;-1;None;05386a8de65066942ab48c279d2128fa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;21;-2145.964,126.482;Inherit;False;0;0;1;3;3;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;12;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;32;-1982.266,534.5593;Inherit;False;InstancedProperty;_CSpeed;ConsuptionSpeed;1;0;Create;False;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-1536.941,540.3735;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;53;-756.571,153.132;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0.8,0.8,0.8,0;False;1;COLOR;0
WireConnection;2;0;17;0
WireConnection;4;0;17;0
WireConnection;6;0;21;0
WireConnection;7;0;6;0
WireConnection;3;1;18;0
WireConnection;1;0;17;0
WireConnection;18;0;2;0
WireConnection;18;1;1;0
WireConnection;28;1;27;0
WireConnection;26;1;28;0
WireConnection;17;0;22;0
WireConnection;31;0;32;0
WireConnection;5;0;21;0
WireConnection;39;0;36;0
WireConnection;0;2;49;0
WireConnection;8;0;5;0
WireConnection;8;1;7;0
WireConnection;48;1;8;0
WireConnection;46;0;45;0
WireConnection;46;1;39;0
WireConnection;49;0;53;0
WireConnection;49;1;23;0
WireConnection;23;1;26;0
WireConnection;21;0;3;0
WireConnection;21;1;4;0
WireConnection;27;0;31;0
WireConnection;53;0;46;0
WireConnection;53;1;48;0
ASEEND*/
//CHKSM=32E485A1BB9881CDAF6025A5198ED96333626C04