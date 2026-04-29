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

        _gaugeSpeed("gaugeSpeed", Float) = 2
        _MainColor("MainColor", Color) = (0,1,0.4785252,1)
        _gaugeValue("gaugeValue", Float) = 1
        _SecondaryColor("SecondaryColor", Color) = (0.7971698,1,0.9946395,1)
        _InitialSize("InitialSize", Vector) = (1,0.3,0,0)
        _InitialSize1("InitialSize", Vector) = (0.05,0.5,0,0)

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

            UNITY_INSTANCING_BUFFER_START(GaugeMat)
            	UNITY_DEFINE_INSTANCED_PROP(float4, _SecondaryColor)
#define _SecondaryColor_arr GaugeMat
            	UNITY_DEFINE_INSTANCED_PROP(float4, _MainColor)
#define _MainColor_arr GaugeMat
            	UNITY_DEFINE_INSTANCED_PROP(float2, _InitialSize)
#define _InitialSize_arr GaugeMat
            	UNITY_DEFINE_INSTANCED_PROP(float2, _InitialSize1)
#define _InitialSize1_arr GaugeMat
            	UNITY_DEFINE_INSTANCED_PROP(float, _gaugeSpeed)
#define _gaugeSpeed_arr GaugeMat
            	UNITY_DEFINE_INSTANCED_PROP(float, _gaugeValue)
#define _gaugeValue_arr GaugeMat
            UNITY_INSTANCING_BUFFER_END(GaugeMat)
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
            			for ( int j = -2; j <= 2; j++ )
            			{
            				for ( int i = -2; i <= 2; i++ )
            			 	{
            			 		float2 g = float2( i, j );
            			 		float2 o = voronoihash1( n + g );
            					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
            					float d = 0.707 * sqrt(dot( r, r ));
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

                float4 _SecondaryColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_SecondaryColor_arr, _SecondaryColor);
                float4 _MainColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainColor_arr, _MainColor);
                float4 blendOpSrc11 = _SecondaryColor_Instance;
                float4 blendOpDest11 = _MainColor_Instance;
                float _gaugeSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_gaugeSpeed_arr, _gaugeSpeed);
                float temp_output_18_0 = ( _gaugeSpeed_Instance == 1.0 ? 1.0 : 4.0 );
                float mulTime4 = _Time.y * ( temp_output_18_0 * 8.0 );
                float time1 = mulTime4;
                float2 voronoiSmoothId1 = 0;
                float2 coords1 = IN.texcoord.xy * 6.0;
                float2 id1 = 0;
                float2 uv1 = 0;
                float fade1 = 0.5;
                float voroi1 = 0;
                float rest1 = 0;
                for( int it1 = 0; it1 <4; it1++ ){
                voroi1 += fade1 * voronoi1( coords1, time1, id1, uv1, 0,voronoiSmoothId1 );
                rest1 += fade1;
                coords1 *= 2;
                fade1 *= 0.5;
                }//Voronoi1
                voroi1 /= rest1;
                float smoothstepResult49 = smoothstep( 0.21 , step( voroi1 , 0.05 ) , voroi1);
                float4 lerpBlendMode11 = lerp(blendOpDest11,(( blendOpSrc11 > 0.5 ) ? max( blendOpDest11, 2.0 * ( blendOpSrc11 - 0.5 ) ) : min( blendOpDest11, 2.0 * blendOpSrc11 ) ),smoothstepResult49);
                float _gaugeValue_Instance = UNITY_ACCESS_INSTANCED_PROP(_gaugeValue_arr, _gaugeValue);
                float2 appendResult15 = (float2(( 1.0 - _gaugeValue_Instance ) , 0.0));
                float2 texCoord14 = IN.texcoord.xy * float2( 1,1 ) + appendResult15;
                float2 _InitialSize_Instance = UNITY_ACCESS_INSTANCED_PROP(_InitialSize_arr, _InitialSize);
                float2 appendResult10_g1 = (float2(_InitialSize_Instance.x , _InitialSize_Instance.y));
                float2 temp_output_11_0_g1 = ( abs( (texCoord14*2.0 + -1.0) ) - appendResult10_g1 );
                float2 break16_g1 = ( 1.0 - ( temp_output_11_0_g1 / fwidth( temp_output_11_0_g1 ) ) );
                float2 appendResult30 = (float2(( 0.5 - _gaugeValue_Instance ) , 0.0));
                float2 texCoord29 = IN.texcoord.xy * float2( 1,1 ) + appendResult30;
                float2 _InitialSize1_Instance = UNITY_ACCESS_INSTANCED_PROP(_InitialSize1_arr, _InitialSize1);
                float2 appendResult10_g2 = (float2(_InitialSize1_Instance.x , _InitialSize1_Instance.y));
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
                float smoothstepResult50 = smoothstep( 0.41 , -0.36 , voroi19);
                

                half4 color = ( ( saturate( lerpBlendMode11 )) * ( saturate( min( break16_g1.x , break16_g1.y ) ) + ( ( temp_output_18_0 - 1.0 ) * saturate( min( break16_g2.x , break16_g2.y ) ) * step( voroi19 , smoothstepResult50 ) ) ) );

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
Node;AmplifyShaderEditor.SimpleSubtractOpNode;16;-543.1999,92.39998;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;-374.1998,72.39998;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-410.9816,770.2769;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-213.8004,76.25155;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;10;-166.8573,212.4678;Inherit;False;InstancedProperty;_InitialSize;InitialSize;4;0;Create;True;0;0;0;False;0;False;1,0.3;1,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;25;-805.5935,518.0975;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;9;199.2872,141.1952;Inherit;True;Rectangle;-1;;1;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;0.5;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;901.6103,276.2631;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;1209.808,7.977341;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;21;1534.932,15.10447;Float;False;True;-1;2;ASEMaterialInspector;0;3;GaugeMat;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;3;1;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;True;True;True;True;True;0;True;_ColorMask;False;False;False;False;False;False;False;True;True;0;True;_Stencil;255;True;_StencilReadMask;255;True;_StencilWriteMask;0;True;_StencilComp;0;True;_StencilOp;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;0;True;unity_GUIZTestMode;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SimpleTimeNode;4;-631.3011,-56.98903;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-860.3782,-57.33699;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;18;-1096.675,139.7292;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;3;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;-740.5205,754.137;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;30;-578.4117,761.7056;Inherit;False;FLOAT2;4;0;FLOAT;-0.5;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1001.852,409.9729;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;12;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;11;528.3951,-355.7175;Inherit;True;PinLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.VoronoiNode;1;-411,-227;Inherit;True;1;1;1;2;4;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;6;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.StepOpNode;45;-96.9789,-131.6222;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;49;207.0273,-199.0045;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.21;False;2;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;35;322.6312,1052.1;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.09;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;50;-59.67996,1188.104;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.41;False;2;FLOAT;-0.36;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;19;-402.671,1059.504;Inherit;True;2;4;5;4;8;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;8;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;570.7635,574.3664;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;43;-34.59068,538.1049;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;27;-351.3573,902.473;Inherit;False;InstancedProperty;_InitialSize1;InitialSize;5;0;Create;True;0;0;0;False;0;False;0.05,0.5;0.1,0.25;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;26;-56.15683,825.6364;Inherit;True;Rectangle;-1;;2;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;0.5;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-325.8,-1118.3;Inherit;False;InstancedProperty;_SecondaryColor;SecondaryColor;3;0;Create;True;0;0;0;False;0;False;0.7971698,1,0.9946395,1;0.4009434,1,0.9342058,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-347.0629,-821.7991;Inherit;False;InstancedProperty;_MainColor;MainColor;1;0;Create;True;0;0;0;False;0;False;0,1,0.4785252,1;0.490196,0,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-1461.757,340.4668;Inherit;False;InstancedProperty;_gaugeSpeed;gaugeSpeed;0;0;Create;True;0;0;0;False;0;False;2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1441.142,146.6178;Inherit;False;InstancedProperty;_gaugeValue;gaugeValue;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
WireConnection;16;1;8;0
WireConnection;15;0;16;0
WireConnection;29;1;30;0
WireConnection;14;1;15;0
WireConnection;25;0;24;0
WireConnection;9;1;14;0
WireConnection;9;2;10;1
WireConnection;9;3;10;2
WireConnection;42;0;9;0
WireConnection;42;1;28;0
WireConnection;3;0;11;0
WireConnection;3;1;42;0
WireConnection;21;0;3;0
WireConnection;4;0;7;0
WireConnection;7;0;18;0
WireConnection;18;0;5;0
WireConnection;31;1;8;0
WireConnection;30;0;31;0
WireConnection;24;0;18;0
WireConnection;11;0;12;0
WireConnection;11;1;2;0
WireConnection;11;2;49;0
WireConnection;1;1;4;0
WireConnection;45;0;1;0
WireConnection;49;0;1;0
WireConnection;49;2;45;0
WireConnection;35;0;19;0
WireConnection;35;1;50;0
WireConnection;50;0;19;0
WireConnection;19;1;25;0
WireConnection;28;0;43;0
WireConnection;28;1;26;0
WireConnection;28;2;35;0
WireConnection;43;0;18;0
WireConnection;26;1;29;0
WireConnection;26;2;27;1
WireConnection;26;3;27;2
ASEEND*/
//CHKSM=3E6F334B13419799DC66B83F646FFCB48684B914