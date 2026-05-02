// Upgrade NOTE: upgraded instancing buffer 'GaugeMat' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GaugeMat"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0

        _TimeScale("TimeScale", Float) = 2
        _PulseColor("PulseColor", Color) = (0,1,1,0)
        _BaseColor("BaseColor", Color) = (0.6704478,0,1,0)
        _gaugeValue("gaugeValue", Float) = 1
        _Scale("Scale", Float) = 4
        _InitialSize("InitialSize", Vector) = (1,0.3,0,0)
        _OverflowSize("OverflowSize", Vector) = (0.05,0.5,0,0)

    }

    SubShader
    {
		LOD 0

        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

        Stencil
        {
        	Ref [_Stencil]
        	ReadMask [_StencilReadMask]
        	WriteMask [_StencilWriteMask]
        	Comp [_StencilComp]
        	Pass [_StencilOp]
        }


        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Blend One OneMinusSrcAlpha
        ColorMask [_ColorMask]

        
        Pass
        {
            Name "Default"
        CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            #pragma multi_compile_local _ UNITY_UI_CLIP_RECT
            #pragma multi_compile_local _ UNITY_UI_ALPHACLIP

            #include "UnityShaderVariables.cginc"
            #pragma multi_compile_instancing


            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                float2 texcoord  : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
                float4  mask : TEXCOORD2;
                UNITY_VERTEX_OUTPUT_STEREO
                
            };

            sampler2D _MainTex;
            fixed4 _Color;
            fixed4 _TextureSampleAdd;
            float4 _ClipRect;
            float4 _MainTex_ST;
            float _UIMaskSoftnessX;
            float _UIMaskSoftnessY;

            uniform float _Scale;
            UNITY_INSTANCING_BUFFER_START(GaugeMat)
            	UNITY_DEFINE_INSTANCED_PROP(float4, _BaseColor)
#define _BaseColor_arr GaugeMat
            	UNITY_DEFINE_INSTANCED_PROP(float4, _PulseColor)
#define _PulseColor_arr GaugeMat
            	UNITY_DEFINE_INSTANCED_PROP(float2, _InitialSize)
#define _InitialSize_arr GaugeMat
            	UNITY_DEFINE_INSTANCED_PROP(float2, _OverflowSize)
#define _OverflowSize_arr GaugeMat
            	UNITY_DEFINE_INSTANCED_PROP(float, _TimeScale)
#define _TimeScale_arr GaugeMat
            	UNITY_DEFINE_INSTANCED_PROP(float, _gaugeValue)
#define _gaugeValue_arr GaugeMat
            UNITY_INSTANCING_BUFFER_END(GaugeMat)
            		float2 voronoihash58( float2 p )
            		{
            			
            			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
            			return frac( sin( p ) *43758.5453);
            		}
            
            		float voronoi58( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
            			 		float2 o = voronoihash58( n + g );
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
            
            		float2 voronoihash19( float2 p )
            		{
            			
            			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
            			return frac( sin( p ) *43758.5453);
            		}
            
            		float voronoi19( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
            			 		float2 o = voronoihash19( n + g );
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
            float2 o = voronoihash19( n + g );
            		o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
            float d = dot( 0.5 * ( r + mr ), normalize( r - mr ) );
            F1 = min( F1, d );
            }
            }
            return F1;
            		}
            

            
            v2f vert(appdata_t v )
            {
                v2f OUT;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);

                

                v.vertex.xyz +=  float3( 0, 0, 0 ) ;

                float4 vPosition = UnityObjectToClipPos(v.vertex);
                OUT.worldPosition = v.vertex;
                OUT.vertex = vPosition;

                float2 pixelSize = vPosition.w;
                pixelSize /= float2(1, 1) * abs(mul((float2x2)UNITY_MATRIX_P, _ScreenParams.xy));

                float4 clampedRect = clamp(_ClipRect, -2e10, 2e10);
                float2 maskUV = (v.vertex.xy - clampedRect.xy) / (clampedRect.zw - clampedRect.xy);
                OUT.texcoord = v.texcoord;
                OUT.mask = float4(v.vertex.xy * 2 - clampedRect.xy - clampedRect.zw, 0.25 / (0.25 * half2(_UIMaskSoftnessX, _UIMaskSoftnessY) + abs(pixelSize.xy)));

                OUT.color = v.color * _Color;
                return OUT;
            }

            fixed4 frag(v2f IN ) : SV_Target
            {
                //Round up the alpha color coming from the interpolator (to 1.0/256.0 steps)
                //The incoming alpha could have numerical instability, which makes it very sensible to
                //HDR color transparency blend, when it blends with the world's texture.
                const half alphaPrecision = half(0xff);
                const half invAlphaPrecision = half(1.0/alphaPrecision);
                IN.color.a = round(IN.color.a * alphaPrecision)*invAlphaPrecision;

                float4 _BaseColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_BaseColor_arr, _BaseColor);
                float _TimeScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_TimeScale_arr, _TimeScale);
                float temp_output_18_0 = ( _TimeScale_Instance == 1.0 ? 1.0 : 4.0 );
                float mulTime63 = _Time.y * ( temp_output_18_0 * 2.0 );
                float time58 = ( mulTime63 * temp_output_18_0 );
                float2 voronoiSmoothId58 = 0;
                float2 temp_cast_0 = (_Scale).xx;
                float2 temp_cast_1 = (_Scale).xx;
                float2 texCoord61 = IN.texcoord.xy * temp_cast_0 + temp_cast_1;
                float2 coords58 = texCoord61 * 1.0;
                float2 id58 = 0;
                float2 uv58 = 0;
                float fade58 = 0.5;
                float voroi58 = 0;
                float rest58 = 0;
                for( int it58 = 0; it58 <3; it58++ ){
                voroi58 += fade58 * voronoi58( coords58, time58, id58, uv58, 0,voronoiSmoothId58 );
                rest58 += fade58;
                coords58 *= 2;
                fade58 *= 0.5;
                }//Voronoi58
                voroi58 /= rest58;
                float smoothstepResult57 = smoothstep( 0.1 , 0.15 , voroi58);
                float4 _PulseColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_PulseColor_arr, _PulseColor);
                float _gaugeValue_Instance = UNITY_ACCESS_INSTANCED_PROP(_gaugeValue_arr, _gaugeValue);
                float2 appendResult15 = (float2(( 1.0 - _gaugeValue_Instance ) , 0.0));
                float2 texCoord14 = IN.texcoord.xy * float2( 1,1 ) + appendResult15;
                float2 _InitialSize_Instance = UNITY_ACCESS_INSTANCED_PROP(_InitialSize_arr, _InitialSize);
                float2 appendResult10_g3 = (float2(_InitialSize_Instance.x , _InitialSize_Instance.y));
                float2 temp_output_11_0_g3 = ( abs( (texCoord14*2.0 + -1.0) ) - appendResult10_g3 );
                float2 break16_g3 = ( 1.0 - ( temp_output_11_0_g3 / fwidth( temp_output_11_0_g3 ) ) );
                float2 appendResult30 = (float2(( 0.5 - _gaugeValue_Instance ) , 0.0));
                float2 texCoord29 = IN.texcoord.xy * float2( 1,1 ) + appendResult30;
                float2 _OverflowSize_Instance = UNITY_ACCESS_INSTANCED_PROP(_OverflowSize_arr, _OverflowSize);
                float2 appendResult10_g2 = (float2(_OverflowSize_Instance.x , _OverflowSize_Instance.y));
                float2 temp_output_11_0_g2 = ( abs( (texCoord29*2.0 + -1.0) ) - appendResult10_g2 );
                float2 break16_g2 = ( 1.0 - ( temp_output_11_0_g2 / fwidth( temp_output_11_0_g2 ) ) );
                float mulTime25 = _Time.y * ( temp_output_18_0 * 12.0 );
                float time19 = mulTime25;
                float2 voronoiSmoothId19 = 0;
                float2 coords19 = IN.texcoord.xy * 8.0;
                float2 id19 = 0;
                float2 uv19 = 0;
                float fade19 = 0.5;
                float voroi19 = 0;
                float rest19 = 0;
                for( int it19 = 0; it19 <8; it19++ ){
                voroi19 += fade19 * voronoi19( coords19, time19, id19, uv19, 0,voronoiSmoothId19 );
                rest19 += fade19;
                coords19 *= 2;
                fade19 *= 0.5;
                }//Voronoi19
                voroi19 /= rest19;
                float smoothstepResult50 = smoothstep( 0.1 , 0.0 , voroi19);
                

                half4 color = ( ( ( _BaseColor_Instance * smoothstepResult57 ) + ( _PulseColor_Instance * ( 1.0 - smoothstepResult57 ) ) ) * ( saturate( min( break16_g3.x , break16_g3.y ) ) + ( ( temp_output_18_0 - 1.0 ) * saturate( min( break16_g2.x , break16_g2.y ) ) * step( voroi19 , smoothstepResult50 ) ) ) );

                #ifdef UNITY_UI_CLIP_RECT
                half2 m = saturate((_ClipRect.zw - _ClipRect.xy - abs(IN.mask.xy)) * IN.mask.zw);
                color.a *= m.x * m.y;
                #endif

                #ifdef UNITY_UI_ALPHACLIP
                clip (color.a - 0.001);
                #endif

                color.rgb *= color.a;

                return color;
            }
        ENDCG
        }
    }
    CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.SimpleSubtractOpNode;16;-675.8463,-306.949;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;-506.8461,-326.9491;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-346.4467,-323.0975;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;10;-299.5036,-186.8808;Inherit;False;InstancedProperty;_InitialSize;InitialSize;5;0;Create;True;0;0;0;False;0;False;1,0.3;1,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;63;-1064.305,-451.058;Inherit;False;1;0;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1270.908,-492.107;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;57;-410.1992,-582.3904;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-805.0027,-463.7056;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;61;-865.9704,-596.9188;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;6,6;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;62;-1034.349,-545.6206;Inherit;False;Property;_Scale;Scale;4;0;Create;True;0;0;0;False;0;False;4;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;51;-141.9851,-438.3368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;42.4571,-586.338;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;55;-411.0058,-758.1453;Inherit;False;InstancedProperty;_PulseColor;PulseColor;1;0;Create;True;0;0;0;False;0;False;0,1,1,0;0,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;56;-411.2942,-929.9319;Inherit;False;InstancedProperty;_BaseColor;BaseColor;2;0;Create;True;0;0;0;False;0;False;0.6704478,0,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;44.36886,-690.5718;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;213.4574,-689.0685;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;9;-84.15883,-314.0534;Inherit;True;Rectangle;-1;;3;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;0.5;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-53.7057,-87.81672;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;43;-293.2908,-46.89512;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;498.375,-321.8827;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;21;724.0006,-325.5617;Float;False;True;-1;2;ASEMaterialInspector;0;3;GaugeMat;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;3;1;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;True;True;True;True;True;0;True;_ColorMask;False;False;False;False;False;False;False;True;True;0;True;_Stencil;255;True;_StencilReadMask;255;True;_StencilWriteMask;0;True;_StencilComp;0;True;_StencilOp;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;0;True;unity_GUIZTestMode;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.VoronoiNode;58;-623.2552,-492.2039;Inherit;False;2;2;1;2;3;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.FunctionNode;26;-325.2388,57.10752;Inherit;False;Rectangle;-1;;2;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;0.5;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-586.9949,63.1087;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;30;-758.425,85.53741;Inherit;False;FLOAT2;4;0;FLOAT;-0.5;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;-919.5336,83.96881;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;27;-542.3706,193.3048;Inherit;False;InstancedProperty;_OverflowSize;OverflowSize;6;0;Create;True;0;0;0;False;0;False;0.05,0.5;0.05,0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.VoronoiNode;19;-775.6843,319.3358;Inherit;False;2;4;5;4;8;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;8;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleAddOpNode;42;182.8075,-313.9416;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1135.14,250.132;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;12;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;50;-576.54,410.0985;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;25;-973.1281,375.9785;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StickyNoteNode;65;-996.4231,460.1664;Inherit;False;251.6317;154.8276;RELMPLACEMENT;;1,1,1,1;Mettre Un dessin d'éclairs animé;0;0
Node;AmplifyShaderEditor.StepOpNode;35;-365.6061,321.3489;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.09;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1193.156,-23.65029;Inherit;False;InstancedProperty;_gaugeValue;gaugeValue;3;0;Create;True;0;0;0;False;0;False;1;0.9665989;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;18;-1645.577,-213.0708;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;3;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1823.058,-144.5333;Inherit;False;InstancedProperty;_TimeScale;TimeScale;0;0;Create;True;0;0;0;False;0;False;2;1;0;0;0;1;FLOAT;0
WireConnection;16;1;8;0
WireConnection;15;0;16;0
WireConnection;14;1;15;0
WireConnection;63;0;7;0
WireConnection;7;0;18;0
WireConnection;57;0;58;0
WireConnection;60;0;63;0
WireConnection;60;1;18;0
WireConnection;61;0;62;0
WireConnection;61;1;62;0
WireConnection;51;0;57;0
WireConnection;52;0;55;0
WireConnection;52;1;51;0
WireConnection;53;0;56;0
WireConnection;53;1;57;0
WireConnection;54;0;53;0
WireConnection;54;1;52;0
WireConnection;9;1;14;0
WireConnection;9;2;10;1
WireConnection;9;3;10;2
WireConnection;28;0;43;0
WireConnection;28;1;26;0
WireConnection;28;2;35;0
WireConnection;43;0;18;0
WireConnection;3;0;54;0
WireConnection;3;1;42;0
WireConnection;21;0;3;0
WireConnection;58;0;61;0
WireConnection;58;1;60;0
WireConnection;26;1;29;0
WireConnection;26;2;27;1
WireConnection;26;3;27;2
WireConnection;29;1;30;0
WireConnection;30;0;31;0
WireConnection;31;1;8;0
WireConnection;19;1;25;0
WireConnection;42;0;9;0
WireConnection;42;1;28;0
WireConnection;24;0;18;0
WireConnection;50;0;19;0
WireConnection;25;0;24;0
WireConnection;35;0;19;0
WireConnection;35;1;50;0
WireConnection;18;0;5;0
ASEEND*/
//CHKSM=F98041F440BB79FDC3567860D2BA8AEAE1BEF379