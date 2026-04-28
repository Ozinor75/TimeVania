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

        _gaugeSpeed("gaugeSpeed", Float) = 1
        _MainColor("MainColor", Color) = (0,1,0.4785252,1)
        _gaugeValue("gaugeValue", Float) = 1
        _InitialSize("InitialSize", Vector) = (1,0.5,0,0)

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
            	UNITY_DEFINE_INSTANCED_PROP(float4, _MainColor)
#define _MainColor_arr GaugeMat
            	UNITY_DEFINE_INSTANCED_PROP(float2, _InitialSize)
#define _InitialSize_arr GaugeMat
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

                float4 _MainColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainColor_arr, _MainColor);
                float4 color12 = IsGammaSpace() ? float4(0.6415094,0.6415094,0.6415094,1) : float4(0.3691636,0.3691636,0.3691636,1);
                float4 blendOpSrc11 = _MainColor_Instance;
                float4 blendOpDest11 = color12;
                float _gaugeSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_gaugeSpeed_arr, _gaugeSpeed);
                float mulTime4 = _Time.y * ( _gaugeSpeed_Instance * 4.0 );
                float time1 = mulTime4;
                float2 voronoiSmoothId1 = 0;
                float2 coords1 = IN.texcoord.xy * 8.66;
                float2 id1 = 0;
                float2 uv1 = 0;
                float voroi1 = voronoi1( coords1, time1, id1, uv1, 0, voronoiSmoothId1 );
                float4 lerpBlendMode11 = lerp(blendOpDest11,(( blendOpSrc11 > 0.5 )? ( blendOpDest11 + 2.0 * blendOpSrc11 - 1.0 ) : ( blendOpDest11 + 2.0 * ( blendOpSrc11 - 0.5 ) ) ),voroi1);
                float _gaugeValue_Instance = UNITY_ACCESS_INSTANCED_PROP(_gaugeValue_arr, _gaugeValue);
                float2 appendResult15 = (float2(( 1.0 - _gaugeValue_Instance ) , 0.0));
                float2 texCoord14 = IN.texcoord.xy * float2( 1,1 ) + appendResult15;
                float2 _InitialSize_Instance = UNITY_ACCESS_INSTANCED_PROP(_InitialSize_arr, _InitialSize);
                float2 appendResult10_g1 = (float2(_InitialSize_Instance.x , _InitialSize_Instance.y));
                float2 temp_output_11_0_g1 = ( abs( (texCoord14*2.0 + -1.0) ) - appendResult10_g1 );
                float2 break16_g1 = ( 1.0 - ( temp_output_11_0_g1 / fwidth( temp_output_11_0_g1 ) ) );
                

                half4 color = ( ( saturate( lerpBlendMode11 )) * saturate( min( break16_g1.x , break16_g1.y ) ) );

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
Node;AmplifyShaderEditor.SimpleTimeNode;4;-633,-213;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;1;-411,-226;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;8.66;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-852,-54;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1116,-191;Inherit;False;InstancedProperty;_gaugeSpeed;gaugeSpeed;0;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;11;143,-237;Inherit;True;LinearLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;519,-74;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;6;825,-60;Float;False;True;-1;2;ASEMaterialInspector;0;3;GaugeMat;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;3;1;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;True;True;True;True;True;0;True;_ColorMask;False;False;False;False;False;False;False;True;True;0;True;_Stencil;255;True;_StencilReadMask;255;True;_StencilWriteMask;0;True;_StencilComp;0;True;_StencilOp;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;0;True;unity_GUIZTestMode;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.FunctionNode;9;-119,543;Inherit;True;Rectangle;-1;;1;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;0.5;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-526,343;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;15;-772,413;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;16;-941,433;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1175,474;Inherit;False;InstancedProperty;_gaugeValue;gaugeValue;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-638,79;Inherit;False;InstancedProperty;_MainColor;MainColor;1;0;Create;True;0;0;0;False;0;False;0,1,0.4785252,1;0,0.8007641,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;12;-107,34;Inherit;False;Constant;_SECONDARY;SECONDARY;2;0;Create;True;0;0;0;False;0;False;0.6415094,0.6415094,0.6415094,1;0.5793943,0,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;10;-477,692;Inherit;False;InstancedProperty;_InitialSize;InitialSize;3;0;Create;True;0;0;0;False;0;False;1,0.5;1,0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
WireConnection;4;0;7;0
WireConnection;1;1;4;0
WireConnection;7;0;5;0
WireConnection;11;0;2;0
WireConnection;11;1;12;0
WireConnection;11;2;1;0
WireConnection;3;0;11;0
WireConnection;3;1;9;0
WireConnection;6;0;3;0
WireConnection;9;1;14;0
WireConnection;9;2;10;1
WireConnection;9;3;10;2
WireConnection;14;1;15;0
WireConnection;15;0;16;0
WireConnection;16;1;8;0
ASEEND*/
//CHKSM=7BF7E6AB534B72FCFC0532ED523BE709713965DD