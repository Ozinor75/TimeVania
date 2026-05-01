// Upgrade NOTE: upgraded instancing buffer 'PowerUp' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PowerUp"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_MainColor("MainColor", Color) = (0.01673412,0,1,1)
		_Scale("Scale", Float) = 6
		_PointColor("PointColor", Color) = (1,1,1,0)
		_CellGradient("CellGradient", Range( 0.2 , 1)) = 1
		_CellSize("CellSize", Range( 0 , 0.5)) = 0.5
		_TimeScale("TimeScale", Float) = 1
		_AnimationSpeed("AnimationSpeed", Float) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
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

		uniform float4 _PointColor;
		uniform half _CellSize;
		uniform half _CellGradient;
		uniform float _AnimationSpeed;
		uniform float _Scale;
		uniform float4 _MainColor;
		uniform float _Cutoff = 0.5;

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
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
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
			
F1 = 8.0;
for ( int j = -2; j <= 2; j++ )
{
for ( int i = -2; i <= 2; i++ )
{
float2 g = mg + float2( i, j );
float2 o = voronoihash1( n + g );
		o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
float d = dot( 0.5 * ( r + mr ), normalize( r - mr ) );
F1 = min( F1, d );
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
			float clampResult24 = clamp( _CellSize , _CellSize , _CellGradient );
			float _TimeScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_TimeScale_arr, _TimeScale);
			float time1 = ( _TimeScale_Instance * _AnimationSpeed * _CosTime.w );
			float2 voronoiSmoothId1 = 0;
			float2 temp_cast_0 = (_Scale).xx;
			float2 temp_cast_1 = (_Scale).xx;
			float2 uv_TexCoord5 = i.uv_texcoord * temp_cast_0 + temp_cast_1;
			float2 coords1 = uv_TexCoord5 * 1.0;
			float2 id1 = 0;
			float2 uv1 = 0;
			float voroi1 = voronoi1( coords1, time1, id1, uv1, 0, voronoiSmoothId1 );
			float smoothstepResult20 = smoothstep( clampResult24 , _CellGradient , voroi1);
			o.Emission = ( ( _PointColor * smoothstepResult20 ) + ( _MainColor * ( 1.0 - smoothstepResult20 ) ) ).rgb;
			o.Alpha = 1;
			clip( step( 0.03 , smoothstepResult20 ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1411,-570.6667;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;PowerUp;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;978.314,-697.5425;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;619.314,-657.5425;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-534,-476.9998;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;4,4;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;1;-195.3334,-394.6665;Inherit;True;0;0;1;4;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;655.314,-466.5425;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;15;498.314,-284.5425;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;20;166.225,-193.286;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;22;563.225,-139.286;Inherit;True;2;0;FLOAT;0.03;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-574,-187.3333;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosTime;29;-832.775,41.71399;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;24;-188.775,-103.286;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-999.775,-236.286;Inherit;False;InstancedProperty;_TimeScale;TimeScale;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-902.775,-89.28601;Inherit;False;Property;_AnimationSpeed;AnimationSpeed;7;0;Create;True;0;0;0;False;0;False;5;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-555.775,-1.28601;Half;False;Property;_CellSize;CellSize;5;0;Create;True;0;0;0;False;0;False;0.5;0.003;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-586.775,182.714;Half;False;Property;_CellGradient;CellGradient;4;0;Create;True;0;0;0;False;0;False;1;1;0.2;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;50.3333,-664.6666;Inherit;False;Property;_PointColor;PointColor;3;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;9;58.39999,-475.3331;Inherit;False;Property;_MainColor;MainColor;1;0;Create;True;0;0;0;False;0;False;0.01673412,0,1,1;1,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-722.775,-433.286;Inherit;False;Property;_Scale;Scale;2;0;Create;True;0;0;0;False;0;False;6;6;0;0;0;1;FLOAT;0
WireConnection;0;2;14;0
WireConnection;0;10;22;0
WireConnection;14;0;12;0
WireConnection;14;1;13;0
WireConnection;12;0;7;0
WireConnection;12;1;20;0
WireConnection;5;0;17;0
WireConnection;5;1;17;0
WireConnection;1;0;5;0
WireConnection;1;1;3;0
WireConnection;13;0;9;0
WireConnection;13;1;15;0
WireConnection;15;0;20;0
WireConnection;20;0;1;0
WireConnection;20;1;24;0
WireConnection;20;2;19;0
WireConnection;22;1;20;0
WireConnection;3;0;25;0
WireConnection;3;1;26;0
WireConnection;3;2;29;4
WireConnection;24;0;23;0
WireConnection;24;1;23;0
WireConnection;24;2;19;0
ASEEND*/
//CHKSM=5C8200166EC6E7CB00893A964D132DF751E8B5D3