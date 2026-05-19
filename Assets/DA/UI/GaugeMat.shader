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

        _TimeScale("TimeScale", Float) = 1
        _BaseColor("BaseColor", Color) = (1,1,1,1)
        _SuperChargedColor("SuperChargedColor", Color) = (1,0.0916364,0,1)
        _gaugeValue("gaugeValue", Float) = 0.5
        _Scale("Scale", Float) = 4
        _TotalLevel("TotalLevel", Float) = 5
        _ActiveLevel("ActiveLevel", Float) = 2
        _FX_Debug("FX_Debug", 2D) = "white" {}

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

            uniform float4 _SuperChargedColor;
            uniform float4 _BaseColor;
            uniform float _Scale;
            uniform sampler2D _FX_Debug;
            UNITY_INSTANCING_BUFFER_START(GaugeMat)
            	UNITY_DEFINE_INSTANCED_PROP(float, _ActiveLevel)
#define _ActiveLevel_arr GaugeMat
            	UNITY_DEFINE_INSTANCED_PROP(float, _TotalLevel)
#define _TotalLevel_arr GaugeMat
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

                float _ActiveLevel_Instance = UNITY_ACCESS_INSTANCED_PROP(_ActiveLevel_arr, _ActiveLevel);
                float _TotalLevel_Instance = UNITY_ACCESS_INSTANCED_PROP(_TotalLevel_arr, _TotalLevel);
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
                float smoothstepResult57 = smoothstep( 0.1 , 0.2 , voroi58);
                float temp_output_84_0 = ( 1.0 - -( ( _ActiveLevel_Instance - _TotalLevel_Instance ) / _TotalLevel_Instance ) );
                float _gaugeValue_Instance = UNITY_ACCESS_INSTANCED_PROP(_gaugeValue_arr, _gaugeValue);
                float2 appendResult66 = (float2(( ( temp_output_84_0 - ( _gaugeValue_Instance * temp_output_84_0 ) ) + -( ( _ActiveLevel_Instance - _TotalLevel_Instance ) / _TotalLevel_Instance ) ) , 0.0));
                float2 texCoord65 = IN.texcoord.xy * float2( 1,1 ) + appendResult66;
                float2 appendResult10_g6 = (float2(1.0 , 0.13));
                float2 temp_output_11_0_g6 = ( abs( (texCoord65*2.0 + -1.0) ) - appendResult10_g6 );
                float2 break16_g6 = ( 1.0 - ( temp_output_11_0_g6 / fwidth( temp_output_11_0_g6 ) ) );
                Gradient gradient99 = NewGradient( 2, 3, 2, float4( 0, 0, 0, 0 ), float4( 0.4386792, 1, 0.9235554, 0.07940795 ), float4( 1, 1, 1, 0.1205921 ), 0, 0, 0, 0, 0, float2( 0, 0 ), float2( 1, 0.06764325 ), 0, 0, 0, 0, 0, 0 );
                float mulTime25 = _Time.y * ( temp_output_18_0 * 12.0 );
                float2 appendResult94 = (float2(1.0 , mulTime25));
                float2 texCoord95 = IN.texcoord.xy * float2( 1,-0.2 ) + appendResult94;
                

                half4 color = ( ( ( ( ( _ActiveLevel_Instance == _TotalLevel_Instance ? _SuperChargedColor : _BaseColor ) * smoothstepResult57 ) + float4( 0,0,0,1 ) ) * saturate( min( break16_g6.x , break16_g6.y ) ) ) + SampleGradient( gradient99, ( ( temp_output_18_0 - 1.0 ) * tex2D( _FX_Debug, texCoord95 ).r ) ) );

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
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;104.1689,-817.9717;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VoronoiNode;58;-638.4566,-631.3037;Inherit;False;2;2;1;2;3;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-825.8026,-461.1056;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;63;-1139.705,-519.9578;Inherit;False;1;0;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;10;-299.5036,-186.8808;Inherit;False;InstancedProperty;_InitialSize;InitialSize;5;0;Create;True;0;0;0;False;0;False;1,1;1,0.9;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;62;-1121.449,-697.7202;Inherit;False;Property;_Scale;Scale;4;0;Create;True;0;0;0;False;0;False;4;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;57;-373.0654,-733.9523;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1516.608,-340.0069;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;272.9603,754.0044;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;21;1291.996,-527.8208;Float;False;True;-1;2;ASEMaterialInspector;0;3;GaugeMat;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;3;1;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;True;True;True;True;True;0;True;_ColorMask;False;False;False;False;False;False;False;True;True;0;True;_Stencil;255;True;_StencilReadMask;255;True;_StencilWriteMask;0;True;_StencilComp;0;True;_StencilOp;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;0;True;unity_GUIZTestMode;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.FunctionNode;9;66.6412,-258.1537;Inherit;True;Rectangle;-1;;5;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;0.5;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;61;-894.5699,-652.8187;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;6,6;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-346.4467,-323.0975;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;15;-719.7497,-307.5344;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;71;-2039.01,190.3148;Inherit;False;2;0;FLOAT;5;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;64;78.01001,79.09178;Inherit;True;Rectangle;-1;;6;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT;0.13;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;75;-1695.989,273.697;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;67;-1854.419,275.4184;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;84;-1437.831,8.624634;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1445.377,-208.7364;Inherit;False;InstancedProperty;_gaugeValue;gaugeValue;3;0;Create;True;0;0;0;False;0;False;0.5;0.9959444;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;16;-937.7499,-270.5343;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;65;-433.705,140.067;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;66;-634.0591,335.5909;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;-751.8311,222.6246;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-1180.831,-68.37537;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;87;-986.8311,-30.37537;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-2387.013,148.3929;Inherit;False;InstancedProperty;_ActiveLevel;ActiveLevel;7;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-2366.013,260.3929;Inherit;False;InstancedProperty;_TotalLevel;TotalLevel;6;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;356.4574,-704.6684;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,1;False;1;COLOR;0
Node;AmplifyShaderEditor.Compare;92;-43.79187,-1051.241;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;56;-485.3511,-1076.635;Inherit;False;Property;_BaseColor;BaseColor;1;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;91;-480.46,-1270.683;Inherit;False;Property;_SuperChargedColor;SuperChargedColor;2;0;Create;True;0;0;0;False;0;False;1,0.0916364,0,1;1,0.09163629,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;25;-996.3278,900.619;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;94;-755.4395,821.8198;Inherit;False;FLOAT2;4;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;93;-77.38959,868.0226;Inherit;True;Property;_FX_Debug;FX_Debug;8;0;Create;True;0;0;0;False;0;False;-1;65314d01c6abc4d409e34df25f9882f4;65314d01c6abc4d409e34df25f9882f4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;95;-556.4395,823.8198;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,-0.2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;-644.9543,589.7577;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;43;-187.1819,623.3257;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1185.086,1018.394;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;12;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;18;-1702.077,693.4292;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;3;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1957.937,640.9407;Inherit;False;InstancedProperty;_TimeScale;TimeScale;0;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GradientSampleNode;100;490.3631,561.5032;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GradientNode;99;202.8754,612.1434;Inherit;False;2;3;2;0,0,0,0;0.4386792,1,0.9235554,0.07940795;1,1,1,0.1205921;0,0;1,0.06764325;0;1;OBJECT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;652.672,-191.348;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;920.2727,-64.92085;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;101;-213.5725,280.4406;Inherit;True;Property;_Barrety_Gauge_DEBUG;Barrety_Gauge_DEBUG;9;0;Create;True;0;0;0;False;0;False;-1;8dcd47943e01d0045afbc5f386d1535f;8dcd47943e01d0045afbc5f386d1535f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;53;0;92;0
WireConnection;53;1;57;0
WireConnection;58;0;61;0
WireConnection;58;1;60;0
WireConnection;60;0;63;0
WireConnection;60;1;18;0
WireConnection;63;0;7;0
WireConnection;57;0;58;0
WireConnection;7;0;18;0
WireConnection;28;0;43;0
WireConnection;28;1;93;1
WireConnection;21;0;42;0
WireConnection;9;1;14;0
WireConnection;9;2;10;1
WireConnection;9;3;10;2
WireConnection;61;0;62;0
WireConnection;61;1;62;0
WireConnection;14;1;15;0
WireConnection;15;0;16;0
WireConnection;71;0;89;0
WireConnection;71;1;90;0
WireConnection;64;1;65;0
WireConnection;75;0;67;0
WireConnection;67;0;71;0
WireConnection;67;1;90;0
WireConnection;84;0;75;0
WireConnection;16;1;8;0
WireConnection;65;1;66;0
WireConnection;66;0;88;0
WireConnection;88;0;87;0
WireConnection;88;1;75;0
WireConnection;86;0;8;0
WireConnection;86;1;84;0
WireConnection;87;0;84;0
WireConnection;87;1;86;0
WireConnection;54;0;53;0
WireConnection;92;0;89;0
WireConnection;92;1;90;0
WireConnection;92;2;91;0
WireConnection;92;3;56;0
WireConnection;25;0;24;0
WireConnection;94;1;25;0
WireConnection;93;1;95;0
WireConnection;95;1;94;0
WireConnection;31;1;8;0
WireConnection;43;0;18;0
WireConnection;24;0;18;0
WireConnection;18;0;5;0
WireConnection;100;0;99;0
WireConnection;100;1;28;0
WireConnection;3;0;54;0
WireConnection;3;1;64;0
WireConnection;42;0;3;0
WireConnection;42;1;100;0
ASEEND*/
//CHKSM=26D43475DE4CBCBF2B4BA546269A22DB3CA72AD4