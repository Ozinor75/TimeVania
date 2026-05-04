// Upgrade NOTE: upgraded instancing buffer 'SkyBox' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SkyBox"
{
	Properties
	{
		_TimeScale("TimeScale", Float) = 0
		_SkyColor("SkyColor", Color) = (0.03706836,0.03706836,0.1603774,0)
		_SkyColor2("SkyColor2", Color) = (0.03706836,0.03706836,0.1603774,0)
		_SkyColor3("SkyColor3", Color) = (0.03706836,0.03706836,0.1603774,0)
		_CloudColor("CloudColor", Color) = (1,1,1,0)
		_GlobalCloudShape("GlobalCloudShape", Vector) = (0,0,0,0)
		_CloudScrollSpeed("CloudScrollSpeed", Float) = 0
		_GlobalCloudSize("GlobalCloudSize", Float) = 4
		_CloudsDensity("CloudsDensity", Range( 0 , 1)) = 4
		_CloudLiveSpeed("CloudLiveSpeed", Float) = 0
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

		uniform float4 _SkyColor;
		uniform float2 _GlobalCloudShape;
		uniform float _CloudScrollSpeed;
		uniform float4 _SkyColor3;
		uniform float4 _SkyColor2;
		uniform float4 _CloudColor;
		uniform float _CloudsDensity;
		uniform float _GlobalCloudSize;
		uniform float _CloudLiveSpeed;

		UNITY_INSTANCING_BUFFER_START(SkyBox)
			UNITY_DEFINE_INSTANCED_PROP(float, _TimeScale)
#define _TimeScale_arr SkyBox
		UNITY_INSTANCING_BUFFER_END(SkyBox)


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


		float2 voronoihash12( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi12( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash12( n + g );
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
			return F2;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			Gradient gradient40 = NewGradient( 0, 3, 3, float4( 1, 0, 0, 0 ), float4( 0, 1, 0, 0.3529412 ), float4( 0, 0, 1, 0.7911803 ), 0, 0, 0, 0, 0, float2( 1, 0.1794156 ), float2( 1, 0.6882429 ), float2( 1, 0.9588311 ), 0, 0, 0, 0, 0 );
			float _TimeScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_TimeScale_arr, _TimeScale);
			float mulTime31 = _Time.y * _TimeScale_Instance;
			float2 appendResult30 = (float2(( mulTime31 * _CloudScrollSpeed ) , 0.0));
			float2 uv_TexCoord29 = i.uv_texcoord * _GlobalCloudShape + appendResult30;
			float4 blendOpSrc8 = ( ( _SkyColor * SampleGradient( gradient40, uv_TexCoord29.y ).b ) + ( _SkyColor3 * SampleGradient( gradient40, uv_TexCoord29.y ).r ) + ( _SkyColor2 * SampleGradient( gradient40, uv_TexCoord29.y ).g ) );
			float4 blendOpDest8 = _CloudColor;
			float time12 = ( mulTime31 * _CloudLiveSpeed );
			float2 voronoiSmoothId12 = 0;
			float2 coords12 = uv_TexCoord29 * _GlobalCloudSize;
			float2 id12 = 0;
			float2 uv12 = 0;
			float fade12 = 0.5;
			float voroi12 = 0;
			float rest12 = 0;
			for( int it12 = 0; it12 <8; it12++ ){
			voroi12 += fade12 * voronoi12( coords12, time12, id12, uv12, 0,voronoiSmoothId12 );
			rest12 += fade12;
			coords12 *= 2;
			fade12 *= 0.5;
			}//Voronoi12
			voroi12 /= rest12;
			float smoothstepResult28 = smoothstep( 0.0 , _CloudsDensity , voroi12);
			float4 lerpBlendMode8 = lerp(blendOpDest8,(( blendOpSrc8 > 0.5 ) ? max( blendOpDest8, 2.0 * ( blendOpSrc8 - 0.5 ) ) : min( blendOpDest8, 2.0 * blendOpSrc8 ) ),smoothstepResult28);
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
Node;AmplifyShaderEditor.DynamicAppendNode;30;-422.2958,48.29764;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-965.295,40.29765;Inherit;False;InstancedProperty;_TimeScale;TimeScale;0;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-592.5564,46.43939;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;31;-800,32;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-594.5564,158.4394;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-839.5564,203.4394;Inherit;False;Property;_CloudLiveSpeed;CloudLiveSpeed;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-850.5564,116.4394;Inherit;False;Property;_CloudScrollSpeed;CloudScrollSpeed;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-52.5564,388.4394;Inherit;False;Property;_CloudsDensity;CloudsDensity;8;0;Create;True;0;0;0;False;0;False;4;0.29;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;33;-473.2958,-140.7023;Inherit;False;Property;_GlobalCloudShape;GlobalCloudShape;5;0;Create;True;0;0;0;False;0;False;0,0;0.5,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;9;327.7859,51.73918;Inherit;False;Property;_CloudColor;CloudColor;4;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;12;72.77544,44.66617;Inherit;True;0;0;1;1;8;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;8;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;34;-186.2958,176.2976;Inherit;False;Property;_GlobalCloudSize;GlobalCloudSize;7;0;Create;True;0;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;28;306.7682,246.0925;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-217.2957,-6.702359;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;37.40247,-1004.276;Inherit;False;Property;_SkyColor;SkyColor;1;0;Create;True;0;0;0;False;0;False;0.03706836,0.03706836,0.1603774,0;0.2500957,0.3113208,0.1953097,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;55;856.463,-665.672;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;8;1047.526,-185.5685;Inherit;True;PinLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;56;50.46301,-625.672;Inherit;False;Property;_SkyColor3;SkyColor3;3;0;Create;True;0;0;0;False;0;False;0.03706836,0.03706836,0.1603774,0;0.1132075,0.1132075,0.1132075,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;43;46.14359,-826.1609;Inherit;False;Property;_SkyColor2;SkyColor2;2;0;Create;True;0;0;0;False;0;False;0.03706836,0.03706836,0.1603774,0;0,0.01132951,0.1132075,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GradientSampleNode;42;11.4436,-429.5606;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;492.3851,-630.8351;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;482.463,-872.672;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;487.5852,-1124.036;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientNode;40;-211.5564,-438.5606;Inherit;False;0;3;3;1,0,0,0;0,1,0,0.3529412;0,0,1,0.7911803;1,0.1794156;1,0.6882429;1,0.9588311;0;1;OBJECT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;59;1377.96,-200.7285;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;SkyBox;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;30;0;35;0
WireConnection;35;0;31;0
WireConnection;35;1;36;0
WireConnection;31;0;32;0
WireConnection;38;0;31;0
WireConnection;38;1;37;0
WireConnection;12;0;29;0
WireConnection;12;1;38;0
WireConnection;12;2;34;0
WireConnection;28;0;12;0
WireConnection;28;2;39;0
WireConnection;29;0;33;0
WireConnection;29;1;30;0
WireConnection;55;0;53;0
WireConnection;55;1;52;0
WireConnection;55;2;57;0
WireConnection;8;0;55;0
WireConnection;8;1;9;0
WireConnection;8;2;28;0
WireConnection;42;0;40;0
WireConnection;42;1;29;2
WireConnection;52;0;56;0
WireConnection;52;1;42;1
WireConnection;57;0;43;0
WireConnection;57;1;42;2
WireConnection;53;0;6;0
WireConnection;53;1;42;3
WireConnection;59;2;8;0
ASEEND*/
//CHKSM=CAE3986597ADEC67B002C5AEB7DC763BF0A9B36D