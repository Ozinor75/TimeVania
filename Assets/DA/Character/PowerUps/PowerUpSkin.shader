// Upgrade NOTE: upgraded instancing buffer 'PowerUp' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PowerUp"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Bolt1("Bolt1", 2D) = "white" {}
		_Scale("Scale", Float) = 6
		_Bolt2("Bolt2", 2D) = "white" {}
		_Bolt3("Bolt2", 2D) = "white" {}
		_BoltColor("BoltColor", Color) = (1,1,1,0)
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

		uniform sampler2D _Bolt1;
		uniform sampler2D _Bolt2;
		uniform sampler2D _Bolt3;
		uniform float4 _BoltColor;
		uniform half _CellSize;
		uniform half _CellGradient;
		uniform float _AnimationSpeed;
		uniform float _Scale;
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
			float mulTime42 = _Time.y * 0.62;
			float2 appendResult55 = (float2(( mulTime42 * 0.73 ) , 9.0));
			float2 uv_TexCoord39 = i.uv_texcoord * float2( 0.1,0.21 ) + appendResult55;
			float2 appendResult61 = (float2(uv_TexCoord39.y , uv_TexCoord39.x));
			float mulTime58 = _Time.y * 0.05;
			float2 appendResult56 = (float2(( mulTime58 * 4.0 ) , 0.0));
			float2 uv_TexCoord37 = i.uv_texcoord * float2( 0.26,0.1 ) + appendResult56;
			float2 appendResult62 = (float2(uv_TexCoord37.y , uv_TexCoord37.x));
			float2 appendResult65 = (float2(uv_TexCoord37.y , ( uv_TexCoord37.x + 0.25 )));
			float Bolt35 = ( ( tex2D( _Bolt1, appendResult61 ).r * 0.8 ) + ( tex2D( _Bolt2, appendResult62 ).r * 0.9 ) + tex2D( _Bolt3, appendResult65 ).r );
			float4 temp_output_45_0 = ( Bolt35 * _BoltColor );
			float clampResult24 = clamp( _CellSize , _CellSize , _CellGradient );
			float _TimeScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_TimeScale_arr, _TimeScale);
			float time1 = ( _TimeScale_Instance * _AnimationSpeed * _CosTime.w );
			float2 voronoiSmoothId1 = 0;
			float2 temp_cast_0 = (_Scale).xx;
			float2 temp_cast_1 = (_Scale).xx;
			float2 uv_TexCoord5 = i.uv_texcoord * temp_cast_0 + temp_cast_1;
			float cos51 = cos( 1.0 * _Time.y );
			float sin51 = sin( 1.0 * _Time.y );
			float2 rotator51 = mul( uv_TexCoord5 - float2( 1,1 ) , float2x2( cos51 , -sin51 , sin51 , cos51 )) + float2( 1,1 );
			float2 coords1 = rotator51 * 1.0;
			float2 id1 = 0;
			float2 uv1 = 0;
			float voroi1 = voronoi1( coords1, time1, id1, uv1, 0, voronoiSmoothId1 );
			float smoothstepResult20 = smoothstep( clampResult24 , _CellGradient , voroi1);
			float4 blendOpSrc49 = temp_output_45_0;
			float4 blendOpDest49 = ( temp_output_45_0 + ( ( 0.0 * smoothstepResult20 ) + ( 0.0 * ( 1.0 - smoothstepResult20 ) ) ) );
			o.Emission = ( saturate( (( blendOpSrc49 > 0.5 ) ? max( blendOpDest49, 2.0 * ( blendOpSrc49 - 0.5 ) ) : min( blendOpDest49, 2.0 * blendOpSrc49 ) ) )).rgb;
			o.Alpha = 1;
			clip( Bolt35 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.SmoothstepOpNode;20;68.29315,-274.8959;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;24;-121.1553,-117.2763;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;1;-141.704,-401.6616;Inherit;True;0;0;1;4;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-457.4144,-200.1577;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-439.1895,-14.11044;Half;False;Property;_CellSize;CellSize;7;0;Create;True;0;0;0;False;0;False;0.5;0.031;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-438.7113,71.95773;Half;False;Property;_CellGradient;CellGradient;6;0;Create;True;0;0;0;False;0;False;1;0.722;0.2;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosTime;29;-645.0724,13.73341;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;-711.575,-78.79331;Inherit;False;Property;_AnimationSpeed;AnimationSpeed;9;0;Create;True;0;0;0;False;0;False;5;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-646.5209,-169.8323;Inherit;False;InstancedProperty;_TimeScale;TimeScale;8;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;345.338,-648.2156;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;362.6844,-473.5376;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;15;366.5724,-283.3766;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;599.4108,-625.2593;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;195.2685,444.341;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;38;-125.837,260.012;Inherit;True;Property;_Bolt1;Bolt1;1;0;Create;True;0;0;0;False;0;False;-1;688a57e387def8f4197eeeae84564b86;942d27e6ad5150040bb5f55937b8ff7c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;46;57.63999,-848.6341;Inherit;False;Property;_BoltColor;BoltColor;5;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.6890518,0.4874213,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;586.7067,-847.5674;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1778.333,-578.6667;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;PowerUp;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;138.8891,-948.6169;Inherit;False;35;Bolt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-658.6755,-424.8736;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;4,4;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-839.769,-441.4314;Inherit;False;Property;_Scale;Scale;2;0;Create;True;0;0;0;False;0;False;6;16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;51;-422.0669,-414.8623;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendOpsNode;49;1152.556,-698.9104;Inherit;True;PinLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;894.506,-633.2339;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;1048.674,66.73626;Inherit;False;Bolt;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-890.8479,358.8036;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.73;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-510.745,346.3207;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.21;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;61;-274.5444,332.8953;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-818.4691,635.0808;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;58;-1074.213,565.5502;Inherit;False;1;0;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;42;-1071.513,456.9134;Inherit;False;1;0;FLOAT;0.62;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;55;-682.8544,341.2846;Inherit;False;FLOAT2;4;0;FLOAT;0.43;False;1;FLOAT;9;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;56;-652.0702,624.2991;Inherit;False;FLOAT2;4;0;FLOAT;0.44;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-496.2043,517.5789;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.26,0.1;False;1;FLOAT2;0,0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;36;-135.7701,471.3811;Inherit;True;Property;_Bolt2;Bolt2;3;0;Create;True;0;0;0;False;0;False;-1;942d27e6ad5150040bb5f55937b8ff7c;688a57e387def8f4197eeeae84564b86;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;63;-118.7552,667.77;Inherit;True;Property;_Bolt3;Bolt2;4;0;Create;True;0;0;0;False;0;False;-1;942d27e6ad5150040bb5f55937b8ff7c;688a57e387def8f4197eeeae84564b86;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;62;-279.0188,514.8622;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;65;-285.0884,676.4365;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;193.15,575.412;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;383.0944,502.7924;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;-411.5547,684.8365;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
WireConnection;20;0;1;0
WireConnection;20;1;24;0
WireConnection;20;2;19;0
WireConnection;24;0;23;0
WireConnection;24;1;23;0
WireConnection;24;2;19;0
WireConnection;1;0;51;0
WireConnection;1;1;3;0
WireConnection;3;0;25;0
WireConnection;3;1;26;0
WireConnection;3;2;29;4
WireConnection;12;1;20;0
WireConnection;13;1;15;0
WireConnection;15;0;20;0
WireConnection;14;0;12;0
WireConnection;14;1;13;0
WireConnection;31;0;38;1
WireConnection;38;1;61;0
WireConnection;45;0;43;0
WireConnection;45;1;46;0
WireConnection;0;2;49;0
WireConnection;0;10;35;0
WireConnection;5;0;17;0
WireConnection;5;1;17;0
WireConnection;51;0;5;0
WireConnection;49;0;45;0
WireConnection;49;1;47;0
WireConnection;47;0;45;0
WireConnection;47;1;14;0
WireConnection;35;0;30;0
WireConnection;33;0;42;0
WireConnection;39;1;55;0
WireConnection;61;0;39;2
WireConnection;61;1;39;1
WireConnection;34;0;58;0
WireConnection;55;0;33;0
WireConnection;56;0;34;0
WireConnection;37;1;56;0
WireConnection;36;1;62;0
WireConnection;63;1;65;0
WireConnection;62;0;37;2
WireConnection;62;1;37;1
WireConnection;65;0;37;2
WireConnection;65;1;64;0
WireConnection;32;0;36;1
WireConnection;30;0;31;0
WireConnection;30;1;32;0
WireConnection;30;2;63;1
WireConnection;64;0;37;1
ASEEND*/
//CHKSM=3CA4C68BCAD6E718437837FDEDD29F9888E627ED