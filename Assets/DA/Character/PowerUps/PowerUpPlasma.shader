// Upgrade NOTE: upgraded instancing buffer 'PowerUp' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PowerUp"
{
	Properties
	{
		_PulseColor("PulseColor", Color) = (0,1,1,0)
		_MainColor("MainColor", Color) = (0.6704478,0,1,0)
		_TimeScale("TimeScale", Float) = 1
		_Scale("Scale", Float) = 4
		_Gradient("Gradient", Vector) = (0,0.2,0,0)
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

		uniform float4 _MainColor;
		uniform float2 _Gradient;
		uniform float _Scale;
		uniform float4 _PulseColor;

		UNITY_INSTANCING_BUFFER_START(PowerUp)
			UNITY_DEFINE_INSTANCED_PROP(float, _TimeScale)
#define _TimeScale_arr PowerUp
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
					float d = 0.5 * ( abs(r.x) + abs(r.y) );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F2 - F1;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float mulTime11 = _Time.y * 4.0;
			float _TimeScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_TimeScale_arr, _TimeScale);
			float time1 = ( mulTime11 * _TimeScale_Instance );
			float2 voronoiSmoothId1 = 0;
			float2 temp_cast_0 = (_Scale).xx;
			float2 temp_cast_1 = (_Scale).xx;
			float2 uv_TexCoord5 = i.uv_texcoord * temp_cast_0 + temp_cast_1;
			float2 coords1 = uv_TexCoord5 * 1.0;
			float2 id1 = 0;
			float2 uv1 = 0;
			float fade1 = 0.5;
			float voroi1 = 0;
			float rest1 = 0;
			for( int it1 = 0; it1 <3; it1++ ){
			voroi1 += fade1 * voronoi1( coords1, time1, id1, uv1, 0,voronoiSmoothId1 );
			rest1 += fade1;
			coords1 *= 2;
			fade1 *= 0.5;
			}//Voronoi1
			voroi1 /= rest1;
			float smoothstepResult10 = smoothstep( _Gradient.x , _Gradient.y , voroi1);
			o.Emission = ( ( _MainColor * smoothstepResult10 ) + ( _PulseColor * ( 1.0 - smoothstepResult10 ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.VoronoiNode;1;-153.3334,-315.6665;Inherit;True;2;2;1;2;3;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleTimeNode;11;-639.6667,-211;Inherit;False;1;0;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;14;397.6892,-168.0829;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;563.9315,-366.7843;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;564.5434,-598.4179;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;814.2319,-485.1146;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-396,-199.3333;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;10;132.3333,-208;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.05;False;2;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-523,-441.9998;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;6,6;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-596.3362,-98.43158;Inherit;False;InstancedProperty;_TimeScale;TimeScale;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-751.3362,-469.4316;Inherit;False;Property;_Scale;Scale;3;0;Create;True;0;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;17;-110.3362,-26.43158;Inherit;False;Property;_Gradient;Gradient;4;0;Create;True;0;0;0;False;0;False;0,0.2;0.1,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;9;236.5686,-556.7915;Inherit;False;Property;_PulseColor;PulseColor;0;0;Create;True;0;0;0;False;0;False;0,1,1,0;0.6705885,0,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;235.6686,-726.0843;Inherit;False;Property;_MainColor;MainColor;1;0;Create;True;0;0;0;False;0;False;0.6704478,0,1,0;0.117647,0.117647,0.2745098,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;20;1187.863,-525.629;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;PowerUp;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;1;0;5;0
WireConnection;1;1;3;0
WireConnection;14;0;10;0
WireConnection;15;0;9;0
WireConnection;15;1;14;0
WireConnection;12;0;7;0
WireConnection;12;1;10;0
WireConnection;13;0;12;0
WireConnection;13;1;15;0
WireConnection;3;0;11;0
WireConnection;3;1;18;0
WireConnection;10;0;1;0
WireConnection;10;1;17;1
WireConnection;10;2;17;2
WireConnection;5;0;16;0
WireConnection;5;1;16;0
WireConnection;20;2;13;0
ASEEND*/
//CHKSM=5C9FB3C94E29025CAA68158D1AE60E18131010BB