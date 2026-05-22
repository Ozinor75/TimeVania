// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ChargingPlasma"
{
	Properties
	{
		_BatteryBase("BatteryBase", 2D) = "white" {}
		_Bolt1("Bolt1", 2D) = "white" {}
		_Bolt2("Bolt2", 2D) = "white" {}
		_Bolt4("Bolt3", 2D) = "white" {}
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
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _BatteryBase;
		uniform float4 _BatteryBase_ST;
		uniform sampler2D _Bolt1;
		uniform sampler2D _Bolt2;
		uniform sampler2D _Bolt4;


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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			Gradient gradient45 = NewGradient( 0, 3, 2, float4( 0.2216792, 0, 1, 0.2294194 ), float4( 0, 0.9600265, 1, 0.6441138 ), float4( 0.5896226, 1, 0.9909807, 1 ), 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float2 uv_BatteryBase = i.uv_texcoord * _BatteryBase_ST.xy + _BatteryBase_ST.zw;
			float4 tex2DNode34 = tex2D( _BatteryBase, uv_BatteryBase );
			float4 appendResult46 = (float4(SampleGradient( gradient45, tex2DNode34.r ).r , SampleGradient( gradient45, tex2DNode34.r ).g , SampleGradient( gradient45, tex2DNode34.r ).b , tex2DNode34.a));
			float mulTime25 = _Time.y * 4.0;
			float2 appendResult32 = (float2(( mulTime25 * 1.5 ) , -0.05));
			float2 uv_TexCoord31 = i.uv_texcoord * float2( 0.17,1.11 ) + appendResult32;
			float2 appendResult33 = (float2(( mulTime25 * 4.0 ) , 0.01));
			float2 uv_TexCoord30 = i.uv_texcoord * float2( 0.2,0.9 ) + appendResult33;
			float2 uv_TexCoord57 = i.uv_texcoord * float2( 0.2,0.26 ) + appendResult33;
			float Bolt27 = ( ( tex2D( _Bolt1, uv_TexCoord31 ).r * 0.8 ) + ( tex2D( _Bolt2, uv_TexCoord30 ).r * 0.9 ) + ( tex2D( _Bolt4, uv_TexCoord57 ).r * 1.0 ) );
			float4 color43 = IsGammaSpace() ? float4(4,4,4,1) : float4(21.11213,21.11213,21.11213,1);
			float4 temp_output_37_0 = ( Bolt27 * color43 );
			float4 blendOpSrc62 = appendResult46;
			float4 blendOpDest62 = temp_output_37_0;
			float4 temp_output_62_0 = ( saturate( min( blendOpSrc62 , blendOpDest62 ) ));
			float2 appendResult65 = (float2(( _CosTime.w * 32.0 * _SinTime.w ) , 0.0));
			float2 uv_TexCoord64 = i.uv_texcoord * appendResult65 + float2( 0.04,0.5 );
			float2 appendResult10_g1 = (float2(0.5 , 1.0));
			float2 temp_output_11_0_g1 = ( abs( (uv_TexCoord64*2.0 + -1.0) ) - appendResult10_g1 );
			float2 break16_g1 = ( 1.0 - ( temp_output_11_0_g1 / fwidth( temp_output_11_0_g1 ) ) );
			o.Emission = ( temp_output_62_0 + ( temp_output_62_0 * saturate( min( break16_g1.x , break16_g1.y ) ) * temp_output_37_0 ) ).rgb;
			o.Alpha = temp_output_62_0.a;
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
Node;AmplifyShaderEditor.SimpleAddOpNode;21;490.5186,-1575.447;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;217.5546,-1631.443;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;105.1059,-59.81135;Inherit;False;27;Bolt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;34;90.22189,-412.3391;Inherit;True;Property;_BatteryBase;BatteryBase;0;0;Create;True;0;0;0;False;0;False;-1;7d611076352158b448ae234ed9ae6996;120fdf3a4079803448d8705ae5120209;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;847.4693,20.28481;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;43;544.37,105.947;Inherit;False;Constant;_Bolt;Bolt;11;1;[HDR];Create;True;0;0;0;False;0;False;4,4,4,1;0,0,0.5019608,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;38;482.3429,-760.6403;Inherit;False;Constant;_Soft;Soft;11;1;[HDR];Create;True;0;0;0;False;0;False;0,0,1,1;0,0,0.5019608,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GradientSampleNode;44;803.7245,-747.8446;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;40;462.6215,-966.5242;Inherit;False;Property;_Beam;Beam;4;1;[HDR];Create;True;0;0;0;False;0;False;0.5531816,0,1,1;0.5516109,20.86591,15.62897,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GradientNode;45;520.4926,-1087.542;Inherit;False;0;3;2;0.2216792,0,1,0.2294194;0,0.9600265,1,0.6441138;0.5896226,1,0.9909807,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;215.4361,-1500.372;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;213.5999,-1335.309;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;-113.484,-1604.403;Inherit;True;Property;_Bolt2;Bolt2;2;0;Create;True;0;0;0;False;0;False;-1;942d27e6ad5150040bb5f55937b8ff7c;942d27e6ad5150040bb5f55937b8ff7c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-753.4744,-1572.892;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-755.2543,-1444.546;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;59;-89.6838,-1416.441;Inherit;True;Property;_Bolt4;Bolt3;3;0;Create;True;0;0;0;False;0;False;-1;942d27e6ad5150040bb5f55937b8ff7c;f80c56b9c5d2bee478895c97dd3b0f7b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;-375.6837,-1382.64;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.2,0.26;False;1;FLOAT2;0,0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;786.5134,-1659.17;Inherit;False;Bolt;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;25;-1063.33,-1488.208;Inherit;False;1;0;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;65;342.234,-167.1106;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinTimeNode;68;-110.3762,-269.0811;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CosTime;71;-131.1469,-117.918;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;46;1190.043,-619.2587;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;63;936.1017,-332.1122;Inherit;True;Rectangle;-1;;1;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;0.5;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;62;1530.317,-420.1392;Inherit;True;Darken;True;3;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;64;493.6971,-286.4927;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.04,0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;20;2304.124,-405.1872;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ChargingPlasma;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.BreakToComponentsNode;54;1843.948,-46.05493;Inherit;True;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;42;1939.219,-349.1577;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-374.731,-1543.29;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.2,0.9;False;1;FLOAT2;0,0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;32;-564.1166,-1572.646;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;-0.05;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-379.5768,-1705.599;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.17,1.11;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;33;-570.1965,-1446.088;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.01;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;26;-103.5509,-1815.772;Inherit;True;Property;_Bolt1;Bolt1;1;0;Create;True;0;0;0;False;0;False;-1;688a57e387def8f4197eeeae84564b86;688a57e387def8f4197eeeae84564b86;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;1607.262,-185.7589;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;131.8929,-190.4071;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;32;False;2;FLOAT;0;False;1;FLOAT;0
WireConnection;21;0;22;0
WireConnection;21;1;24;0
WireConnection;21;2;55;0
WireConnection;22;0;26;1
WireConnection;37;0;36;0
WireConnection;37;1;43;0
WireConnection;44;0;45;0
WireConnection;44;1;34;1
WireConnection;24;0;29;1
WireConnection;55;0;59;1
WireConnection;29;1;30;0
WireConnection;23;0;25;0
WireConnection;28;0;25;0
WireConnection;59;1;57;0
WireConnection;57;1;33;0
WireConnection;27;0;21;0
WireConnection;65;0;66;0
WireConnection;46;0;44;1
WireConnection;46;1;44;2
WireConnection;46;2;44;3
WireConnection;46;3;34;4
WireConnection;63;1;64;0
WireConnection;62;0;46;0
WireConnection;62;1;37;0
WireConnection;64;0;65;0
WireConnection;20;2;42;0
WireConnection;20;9;54;3
WireConnection;54;0;62;0
WireConnection;42;0;62;0
WireConnection;42;1;73;0
WireConnection;30;1;33;0
WireConnection;32;0;23;0
WireConnection;31;1;32;0
WireConnection;33;0;28;0
WireConnection;26;1;31;0
WireConnection;73;0;62;0
WireConnection;73;1;63;0
WireConnection;73;2;37;0
WireConnection;66;0;71;4
WireConnection;66;2;68;4
ASEEND*/
//CHKSM=0C7ED011A6249D6CABFC39617F1E52AA690AE276