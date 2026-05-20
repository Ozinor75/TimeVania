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
        _gaugeValue("gaugeValue", Float) = 0.5
        _TotalLevel("TotalLevel", Float) = 5
        _ActiveLevel("ActiveLevel", Float) = 2
        _SuperchargedFX("SuperchargedFX", 2D) = "white" {}
        _BatteryBase("BatteryBase", 2D) = "white" {}
        _BatteryCrank("BatteryCrank", 2D) = "white" {}
        _UnstableBoltFX("UnstableBoltFX", 2D) = "white" {}
        _StableBoltFX("StableBoltFX", 2D) = "white" {}
        _SuperchargedColor("SuperchargedColor", Color) = (0.5531816,0,1,1)
        _BaseColor("BaseColor", Color) = (0,1,0.9831882,1)
        _BoltColor("BoltColor", Color) = (1,1,1,1)
        _CrankColor("CrankColor", Color) = (0,0,0,1)
        [HideInInspector] _texcoord( "", 2D ) = "white" {}

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

            uniform sampler2D _BatteryCrank;
            uniform sampler2D _BatteryBase;
            uniform sampler2D _UnstableBoltFX;
            uniform sampler2D _StableBoltFX;
            uniform float4 _SuperchargedColor;
            uniform float4 _BaseColor;
            uniform float4 _BoltColor;
            uniform sampler2D _SuperchargedFX;
            uniform float4 _CrankColor;
            UNITY_INSTANCING_BUFFER_START(GaugeMat)
            	UNITY_DEFINE_INSTANCED_PROP(float4, _BatteryBase_ST)
#define _BatteryBase_ST_arr GaugeMat
            	UNITY_DEFINE_INSTANCED_PROP(float, _ActiveLevel)
#define _ActiveLevel_arr GaugeMat
            	UNITY_DEFINE_INSTANCED_PROP(float, _TotalLevel)
#define _TotalLevel_arr GaugeMat
            	UNITY_DEFINE_INSTANCED_PROP(float, _TimeScale)
#define _TimeScale_arr GaugeMat
            	UNITY_DEFINE_INSTANCED_PROP(float, _gaugeValue)
#define _gaugeValue_arr GaugeMat
            UNITY_INSTANCING_BUFFER_END(GaugeMat)

            
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
                float2 appendResult183 = (float2(-( ( _ActiveLevel_Instance - _TotalLevel_Instance ) / _TotalLevel_Instance ) , 0.0));
                float2 texCoord184 = IN.texcoord.xy * float2( 1,1 ) + appendResult183;
                float2 appendResult10_g10 = (float2(1.0 , 1.0));
                float2 temp_output_11_0_g10 = ( abs( (texCoord184*2.0 + -1.0) ) - appendResult10_g10 );
                float2 break16_g10 = ( 1.0 - ( temp_output_11_0_g10 / fwidth( temp_output_11_0_g10 ) ) );
                float2 texCoord186 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0.02 );
                float4 _BatteryBase_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_BatteryBase_ST_arr, _BatteryBase_ST);
                float2 uv_BatteryBase = IN.texcoord.xy * _BatteryBase_ST_Instance.xy + _BatteryBase_ST_Instance.zw;
                float4 tex2DNode101 = tex2D( _BatteryBase, uv_BatteryBase );
                float temp_output_180_0 = ( saturate( min( break16_g10.x , break16_g10.y ) ) * tex2D( _BatteryCrank, texCoord186 ).a * tex2DNode101.r );
                float _TimeScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_TimeScale_arr, _TimeScale);
                float temp_output_18_0 = ( _TimeScale_Instance == 1.0 ? 1.0 : 4.0 );
                float mulTime63 = _Time.y * temp_output_18_0;
                float2 appendResult105 = (float2(( mulTime63 * 1.5 ) , 0.0));
                float2 texCoord61 = IN.texcoord.xy * float2( 0.1,1 ) + appendResult105;
                float2 appendResult161 = (float2(( mulTime63 * 12.0 ) , 0.0));
                float2 texCoord160 = IN.texcoord.xy * float2( 1,1 ) + appendResult161;
                float temp_output_136_0 = ( ( tex2D( _UnstableBoltFX, texCoord61 ).r * 0.8 ) + ( tex2D( _StableBoltFX, texCoord160 ).r * 0.9 ) );
                float temp_output_84_0 = ( 1.0 - -( ( _ActiveLevel_Instance - _TotalLevel_Instance ) / _TotalLevel_Instance ) );
                float _gaugeValue_Instance = UNITY_ACCESS_INSTANCED_PROP(_gaugeValue_arr, _gaugeValue);
                float temp_output_88_0 = ( ( temp_output_84_0 - ( temp_output_84_0 * _gaugeValue_Instance ) ) + -( ( _ActiveLevel_Instance - _TotalLevel_Instance ) / _TotalLevel_Instance ) );
                float2 appendResult66 = (float2(temp_output_88_0 , 0.0));
                float2 texCoord65 = IN.texcoord.xy * float2( 1,1 ) + appendResult66;
                float2 appendResult10_g9 = (float2(1.0 , 1.0));
                float2 temp_output_11_0_g9 = ( abs( (texCoord65*2.0 + -1.0) ) - appendResult10_g9 );
                float2 break16_g9 = ( 1.0 - ( temp_output_11_0_g9 / fwidth( temp_output_11_0_g9 ) ) );
                float mulTime25 = _Time.y * ( temp_output_18_0 * 12.0 );
                float2 appendResult94 = (float2(( temp_output_88_0 + -0.02 ) , mulTime25));
                float2 texCoord95 = IN.texcoord.xy * float2( 1,1 ) + appendResult94;
                float2 appendResult10_g7 = (float2(1.0 , 0.2));
                float2 temp_output_11_0_g7 = ( abs( (IN.texcoord.xy*2.0 + -1.0) ) - appendResult10_g7 );
                float2 break16_g7 = ( 1.0 - ( temp_output_11_0_g7 / fwidth( temp_output_11_0_g7 ) ) );
                float layeredBlendVar191 = saturate( temp_output_180_0 );
                float4 layeredBlend191 = ( lerp( ( ( ( ( ( tex2DNode101.r - temp_output_136_0 ) * ( _ActiveLevel_Instance == _TotalLevel_Instance ? _SuperchargedColor : _BaseColor ) ) + ( temp_output_136_0 * _BoltColor ) ) * saturate( min( break16_g9.x , break16_g9.y ) ) ) + ( ( _BoltColor * ( ( temp_output_18_0 - 1.0 ) * tex2D( _SuperchargedFX, texCoord95 ).r ) ) * saturate( min( break16_g7.x , break16_g7.y ) ) ) ),( temp_output_180_0 * _CrankColor ) , layeredBlendVar191 ) );
                

                half4 color = layeredBlend191;

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
Node;AmplifyShaderEditor.Compare;92;-52.10444,263.3414;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-690.9653,375.8983;Inherit;False;InstancedProperty;_TotalLevel;TotalLevel;2;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;620.8036,443.2903;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;75;-93.92963,628.8691;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;67;-260.3458,658.6985;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;71;-433.094,653.2328;Inherit;False;2;0;FLOAT;5;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-435.2472,773.6824;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;12;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;25;-251.4937,776.6533;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;94;749.7625,706.7693;Inherit;False;FLOAT2;4;0;FLOAT;0.5;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;95;1003.52,730.5406;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;1560.377,615.8879;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;1778.794,475.0984;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;136;198.5154,-491.9926;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;-13.44815,-501.989;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;61;-625.5805,-439.8448;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;161;-789.6992,-247.737;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-969.8558,-252.6929;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;12;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;105;-784.9184,-383.3909;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;155;-972.9767,-388.8373;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-15.56672,-264.9194;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;160;-619.7346,-262.9363;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;162;446.39,-499.1055;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;63;-1260.332,-361.754;Inherit;False;1;0;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1734.701,526.0674;Inherit;False;InstancedProperty;_TimeScale;TimeScale;0;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;257.2704,659.9545;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;2012.917,477.3963;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;172;596.2647,650.6556;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;18;-1539.151,528.6105;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;3;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;173;1377.506,607.2405;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;159;-304.8875,-271.3496;Inherit;True;Property;_StableBoltFX;StableBoltFX;9;0;Create;True;0;0;0;False;0;False;-1;925dee1a36cf6b941a02988f204a0105;677b03417b1fc7745b9d7e6f9879dbb4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;102;-313.9544,-501.7193;Inherit;True;Property;_UnstableBoltFX;UnstableBoltFX;8;0;Create;True;0;0;0;False;0;False;-1;ddc70fc7a4a640a46a84f0f53ca67172;ddc70fc7a4a640a46a84f0f53ca67172;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;164;1767.616,590.4463;Inherit;True;Rectangle;-1;;7;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;93;1241.267,739.3969;Inherit;True;Property;_SuperchargedFX;SuperchargedFX;4;0;Create;True;0;0;0;False;0;False;-1;None;3ccae72f2dc89a74c830fc7c6957bc91;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;176;1730.049,815.2403;Inherit;True;Property;_SuperchargedFXMask;SuperchargedFXMask;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;101;98.70418,224.7582;Inherit;True;Property;_BatteryBase;BatteryBase;6;0;Create;True;0;0;0;False;0;False;-1;4336ccfe5fdae814c9a02e7653bff6cf;4336ccfe5fdae814c9a02e7653bff6cf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;66;782.0054,440.5552;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;65;962.5637,448.0588;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;43.60858,703.2803;Inherit;False;InstancedProperty;_gaugeValue;gaugeValue;1;0;Create;True;0;0;0;False;0;False;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;87;439.1256,447.3788;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;84;75.80076,629.7765;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-690.4136,287.1829;Inherit;False;InstancedProperty;_ActiveLevel;ActiveLevel;3;0;Create;True;0;0;0;False;0;False;2;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;3149.849,174.6769;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;2415.738,158.9336;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;152;2658.776,164.1243;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;64;2852.941,411.7322;Inherit;True;Rectangle;-1;;9;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;3396.846,192.6995;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;151;599.7031,221.2471;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;149;-313.6133,55.94435;Inherit;False;Property;_SuperchargedColor;SuperchargedColor;10;0;Create;True;0;0;0;False;0;False;0.5531816,0,1,1;0.5531816,0,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;142;-313.0001,242.6526;Inherit;False;Property;_BaseColor;BaseColor;11;0;Create;True;0;0;0;False;0;False;0,1,0.9831882,1;0,1,0.9831882,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;163;159.7557,32.49473;Inherit;False;Property;_BoltColor;BoltColor;12;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;177;2568.293,-319.3247;Inherit;True;Property;_BatteryCrank;BatteryCrank;7;0;Create;True;0;0;0;False;0;False;-1;4336ccfe5fdae814c9a02e7653bff6cf;4ba35876c2cab6345b8d3f1056913810;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;185;2610.832,-558.8019;Inherit;True;Rectangle;-1;;10;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;184;2315.49,-563.0532;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;183;2132.668,-565.3294;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;181;2900.658,0.3574604;Inherit;False;Property;_CrankColor;CrankColor;13;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;180;2901.512,-246.8568;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;193;3137.242,-57.38403;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;192;3183.67,-136.5291;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LayeredBlendNode;191;3636.696,80.9072;Inherit;True;6;0;FLOAT;0.5;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;21;3930.567,181.0568;Float;False;True;-1;2;ASEMaterialInspector;0;3;GaugeMat;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;3;1;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;True;True;True;True;True;0;True;_ColorMask;False;False;False;False;False;False;False;True;True;0;True;_Stencil;255;True;_StencilReadMask;255;True;_StencilWriteMask;0;True;_StencilComp;0;True;_StencilOp;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;0;True;unity_GUIZTestMode;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;195;3825.107,-270.3929;Inherit;True;194;FINAL;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;194;4024.648,-273.9214;Inherit;False;FINAL;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;186;2327.775,-252.535;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0.02;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;92;0;89;0
WireConnection;92;1;90;0
WireConnection;92;2;149;0
WireConnection;92;3;142;0
WireConnection;88;0;87;0
WireConnection;88;1;75;0
WireConnection;75;0;67;0
WireConnection;67;0;71;0
WireConnection;67;1;90;0
WireConnection;71;0;89;0
WireConnection;71;1;90;0
WireConnection;24;0;18;0
WireConnection;25;0;24;0
WireConnection;94;0;172;0
WireConnection;94;1;25;0
WireConnection;95;1;94;0
WireConnection;28;0;173;0
WireConnection;28;1;93;1
WireConnection;171;0;163;0
WireConnection;171;1;28;0
WireConnection;136;0;118;0
WireConnection;136;1;120;0
WireConnection;118;0;102;1
WireConnection;61;1;105;0
WireConnection;161;0;60;0
WireConnection;60;0;63;0
WireConnection;105;0;155;0
WireConnection;155;0;63;0
WireConnection;120;0;159;1
WireConnection;160;1;161;0
WireConnection;162;0;136;0
WireConnection;162;1;163;0
WireConnection;63;0;18;0
WireConnection;86;0;84;0
WireConnection;86;1;8;0
WireConnection;165;0;171;0
WireConnection;165;1;164;0
WireConnection;172;0;88;0
WireConnection;18;0;5;0
WireConnection;173;0;18;0
WireConnection;159;1;160;0
WireConnection;102;1;61;0
WireConnection;93;1;95;0
WireConnection;66;0;88;0
WireConnection;65;1;66;0
WireConnection;87;0;84;0
WireConnection;87;1;86;0
WireConnection;84;0;75;0
WireConnection;154;0;152;0
WireConnection;154;1;64;0
WireConnection;153;0;151;0
WireConnection;153;1;92;0
WireConnection;152;0;153;0
WireConnection;152;1;162;0
WireConnection;64;1;65;0
WireConnection;42;0;154;0
WireConnection;42;1;165;0
WireConnection;151;0;101;1
WireConnection;151;1;136;0
WireConnection;177;1;186;0
WireConnection;185;1;184;0
WireConnection;184;1;183;0
WireConnection;183;0;75;0
WireConnection;180;0;185;0
WireConnection;180;1;177;4
WireConnection;180;2;101;1
WireConnection;193;0;180;0
WireConnection;193;1;181;0
WireConnection;192;0;180;0
WireConnection;191;0;192;0
WireConnection;191;1;42;0
WireConnection;191;2;193;0
WireConnection;21;0;191;0
ASEEND*/
//CHKSM=6A8ECA781E55F73FF007F31CEC180293B4840274