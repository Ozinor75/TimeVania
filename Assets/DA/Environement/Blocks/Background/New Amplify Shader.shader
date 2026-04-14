// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SkyBox"
{
	Properties
	{
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
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 color9 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float4 color6 = IsGammaSpace() ? float4(0,0.1098137,0.2641509,0) : float4(0,0.0116139,0.05672633,0);
			float4 blendOpSrc8 = color9;
			float4 blendOpDest8 = color6;
			float2 appendResult11 = (float2(_SinTime.w , _CosTime.w));
			float2 break31_g3 = appendResult11;
			float2 temp_output_15_0_g3 = float2( 32,32 );
			float2 break26_g3 = ( i.uv_texcoord * temp_output_15_0_g3 );
			float2 appendResult27_g3 = (float2(( ( 0.0 * step( 1.0 , ( break26_g3.y % 2.0 ) ) ) + break26_g3.x ) , break26_g3.y));
			float dotResult4_g5 = dot( floor( appendResult27_g3 ) , float2( 12.9898,78.233 ) );
			float lerpResult10_g5 = lerp( break31_g3.x , break31_g3.y , frac( ( sin( dotResult4_g5 ) * 43758.55 ) ));
			float2 break12_g3 = temp_output_15_0_g3;
			float temp_output_21_0_g3 = sign( ( break12_g3.y - break12_g3.x ) );
			float temp_output_14_0_g3 = 0.2;
			float2 appendResult10_g4 = (float2(( ( ( 1.0 / break12_g3.y ) * max( temp_output_21_0_g3 , 0.0 ) ) + temp_output_14_0_g3 ) , ( temp_output_14_0_g3 + ( ( -1.0 / break12_g3.x ) * min( temp_output_21_0_g3 , 0.0 ) ) )));
			float2 temp_output_11_0_g4 = ( abs( (frac( appendResult27_g3 )*2.0 + -1.0) ) - appendResult10_g4 );
			float2 break16_g4 = ( 1.0 - ( temp_output_11_0_g4 / fwidth( temp_output_11_0_g4 ) ) );
			float temp_output_2_0_g3 = saturate( min( break16_g4.x , break16_g4.y ) );
			float4 lerpBlendMode8 = lerp(blendOpDest8,(( blendOpSrc8 > 0.5 )? ( blendOpDest8 + 2.0 * blendOpSrc8 - 1.0 ) : ( blendOpDest8 + 2.0 * ( blendOpSrc8 - 0.5 ) ) ),( lerpResult10_g5 * temp_output_2_0_g3 ));
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
Node;AmplifyShaderEditor.DynamicAppendNode;11;-471.5876,137.1544;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;10;-192.1202,-54.27478;Inherit;True;Bricks Pattern;-1;;3;7d219d3a79fd53a48987a86fa91d6bac;0;4;15;FLOAT2;32,32;False;14;FLOAT;0.2;False;16;FLOAT;0;False;17;FLOAT2;0,1;False;2;FLOAT;0;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-459.879,-204.8655;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CosTime;7;-679.1658,268.8215;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;2;-680.5458,30.46774;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;4;-703.2123,-268.8656;Inherit;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;0;False;0;False;64,64;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;6;-93.87906,-236.8654;Inherit;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0,0.1098137,0.2641509,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;9;-92.49948,-420.5116;Inherit;False;Constant;_Color1;Color 0;0;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;8;456.8338,-96.51172;Inherit;True;LinearLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;897.3334,-185.3333;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;SkyBox;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;2;4
WireConnection;11;1;7;4
WireConnection;10;17;11;0
WireConnection;3;0;4;0
WireConnection;3;1;2;1
WireConnection;8;0;9;0
WireConnection;8;1;6;0
WireConnection;8;2;10;3
WireConnection;0;2;8;0
ASEEND*/
//CHKSM=A5CB48C4A3946B04C369136C130FA5CC5E78B9BF