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
        _BatteryBase("BatteryBase", 2D) = "white" {}
        _BatteryCrank("BatteryCrank", 2D) = "white" {}
        _UnstableBoltFX("UnstableBoltFX", 2D) = "white" {}
        _StableBoltFX("StableBoltFX", 2D) = "white" {}
        _SuperchargedColor("SuperchargedColor", Color) = (0.5531816,0,1,1)
        _BaseColor("BaseColor", Color) = (0,1,0.9831882,1)
        [HDR]_BoltColor("BoltColor", Color) = (1,1,1,1)
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
            uniform float4 _SuperchargedColor;
            uniform float4 _BaseColor;
            uniform sampler2D _UnstableBoltFX;
            uniform sampler2D _StableBoltFX;
            uniform float4 _BoltColor;
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
                float Offset_Level196 = -( ( _ActiveLevel_Instance - _TotalLevel_Instance ) / _TotalLevel_Instance );
                float2 appendResult183 = (float2(Offset_Level196 , 0.0));
                float2 texCoord184 = IN.texcoord.xy * float2( 1,1 ) + appendResult183;
                float2 appendResult10_g10 = (float2(1.0 , 1.0));
                float2 temp_output_11_0_g10 = ( abs( (texCoord184*2.0 + -1.0) ) - appendResult10_g10 );
                float2 break16_g10 = ( 1.0 - ( temp_output_11_0_g10 / fwidth( temp_output_11_0_g10 ) ) );
                float2 texCoord186 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0.02 );
                float4 _BatteryBase_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_BatteryBase_ST_arr, _BatteryBase_ST);
                float2 uv_BatteryBase = IN.texcoord.xy * _BatteryBase_ST_Instance.xy + _BatteryBase_ST_Instance.zw;
                float4 tex2DNode101 = tex2D( _BatteryBase, uv_BatteryBase );
                float temp_output_180_0 = ( saturate( min( break16_g10.x , break16_g10.y ) ) * tex2D( _BatteryCrank, texCoord186 ).a * tex2DNode101.a );
                float4 color204 = IsGammaSpace() ? float4(0,0,1,1) : float4(0,0,1,1);
                float4 blendOpSrc203 = ( Offset_Level196 == 0.0 ? _SuperchargedColor : _BaseColor );
                float4 blendOpDest203 = color204;
                float4 lerpBlendMode203 = lerp(blendOpDest203,( 1.0 - ( 1.0 - blendOpSrc203 ) * ( 1.0 - blendOpDest203 ) ),tex2DNode101.r);
                float _TimeScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_TimeScale_arr, _TimeScale);
                float temp_output_18_0 = ( _TimeScale_Instance == 1.0 ? 1.0 : 4.0 );
                float mulTime63 = _Time.y * temp_output_18_0;
                float2 appendResult105 = (float2(( mulTime63 * 1.5 ) , 0.02));
                float2 texCoord61 = IN.texcoord.xy * float2( 1,1 ) + appendResult105;
                float2 appendResult161 = (float2(( mulTime63 * 4.0 ) , -0.04));
                float2 texCoord160 = IN.texcoord.xy * float2( 1,1 ) + appendResult161;
                float Bolt197 = ( ( tex2D( _UnstableBoltFX, texCoord61 ).r * 0.8 ) + ( tex2D( _StableBoltFX, texCoord160 ).r * 0.9 ) );
                float temp_output_84_0 = ( 1.0 - -( ( _ActiveLevel_Instance - _TotalLevel_Instance ) / _TotalLevel_Instance ) );
                float _gaugeValue_Instance = UNITY_ACCESS_INSTANCED_PROP(_gaugeValue_arr, _gaugeValue);
                float temp_output_88_0 = ( ( temp_output_84_0 - ( temp_output_84_0 * _gaugeValue_Instance ) ) + Offset_Level196 );
                float2 appendResult66 = (float2(temp_output_88_0 , 0.0));
                float2 texCoord65 = IN.texcoord.xy * float2( 1,1 ) + appendResult66;
                float2 appendResult10_g11 = (float2(1.0 , 1.0));
                float2 temp_output_11_0_g11 = ( abs( (texCoord65*2.0 + -1.0) ) - appendResult10_g11 );
                float2 break16_g11 = ( 1.0 - ( temp_output_11_0_g11 / fwidth( temp_output_11_0_g11 ) ) );
                float layeredBlendVar191 = saturate( temp_output_180_0 );
                float4 layeredBlend191 = ( lerp( ( ( ( ( saturate( lerpBlendMode203 )) * ( ( tex2DNode101.r - Bolt197 ) * 1.2 ) ) + ( Bolt197 * _BoltColor ) ) * saturate( min( break16_g11.x , break16_g11.y ) ) ),( temp_output_180_0 * _CrankColor ) , layeredBlendVar191 ) );
                

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
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;3149.849,174.6769;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-809.5601,252.31;Inherit;False;InstancedProperty;_TimeScale;TimeScale;0;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;74.48415,814.3188;Inherit;False;InstancedProperty;_gaugeValue;gaugeValue;1;0;Create;True;0;0;0;False;0;False;0.5;0.9367756;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;84;106.6762,740.816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;196;56.69006,609.1629;Inherit;False;Offset_Level;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;452.9808,639.1153;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;66;597.1162,640.5685;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;65;775.0491,604.7559;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;87;287.5281,635.5686;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;75;-107.7499,608.8267;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;67;-265.297,610.9188;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;71;-425.7044,612.0443;Inherit;False;2;0;FLOAT;5;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;25;-104.5279,813.3368;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-274.4471,789.1541;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;12;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-613.2169,815.6138;Inherit;False;InstancedProperty;_TotalLevel;TotalLevel;2;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;208;2187.628,222.4482;Inherit;False;Property;_Strenght;Strenght;14;0;Create;True;0;0;0;False;0;False;0;-0.331;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;163;2133.97,373.621;Inherit;False;Property;_BoltColor;BoltColor;12;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1.414214,1.414214,1.414214,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;89;-614.0749,610.3343;Inherit;False;InstancedProperty;_ActiveLevel;ActiveLevel;3;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;204;1824.777,204.7238;Inherit;False;Constant;_000;000;11;1;[HDR];Create;True;0;0;0;False;0;False;0,0,1,1;0,0,0.5019608,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;941.2979,-794.4603;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;155;-18.23093,-681.3093;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;939.1794,-557.3899;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;102;640.7924,-794.1902;Inherit;True;Property;_UnstableBoltFX;UnstableBoltFX;8;0;Create;True;0;0;0;False;0;False;-1;688a57e387def8f4197eeeae84564b86;688a57e387def8f4197eeeae84564b86;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-16.11094,-545.1633;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;159;649.8593,-563.8203;Inherit;True;Property;_StableBoltFX;StableBoltFX;9;0;Create;True;0;0;0;False;0;False;-1;942d27e6ad5150040bb5f55937b8ff7c;942d27e6ad5150040bb5f55937b8ff7c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;160;335.0124,-555.4068;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;61;329.1666,-732.3172;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;105;169.8269,-675.8628;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.02;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;161;165.0469,-540.2072;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;-0.04;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;93;1125.08,1371.88;Inherit;True;Property;_SuperchargedFX;SuperchargedFX;4;0;Create;True;0;0;0;False;0;False;-1;7290b7d1f77bad542bc9e9f632890906;7290b7d1f77bad542bc9e9f632890906;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;173;1238.34,1259.355;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;1436.203,1262.237;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;1718.216,1258.65;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;201;1937.47,1254.261;Inherit;False;SuperBolt;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;164;1425.488,1438.605;Inherit;True;Rectangle;-1;;12;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;176;1668.147,1507.714;Inherit;True;Property;_SuperchargedFXMask;SuperchargedFXMask;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;95;781.3648,1197.001;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;94;634.8229,1157.011;Inherit;False;FLOAT2;4;0;FLOAT;0.5;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;172;490.0731,1107.434;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;286.3943,781.5007;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;64;1020.195,601.2935;Inherit;True;Rectangle;-1;;11;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;152;2936.776,185.1243;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;162;2688.012,177.517;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LayeredBlendNode;191;3437.696,37.9072;Inherit;True;6;0;FLOAT;0.5;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;21;3716.968,55.1568;Float;False;True;-1;2;ASEMaterialInspector;0;3;GaugeMat;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;3;1;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;True;True;True;True;True;0;True;_ColorMask;False;False;False;False;False;False;False;True;True;0;True;_Stencil;255;True;_StencilReadMask;255;True;_StencilWriteMask;0;True;_StencilComp;0;True;_StencilOp;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;0;True;unity_GUIZTestMode;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;2769.104,603.5305;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;202;2477.188,590.1236;Inherit;False;201;SuperBolt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;3054.846,603.6995;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;63;-227.1459,-666.3975;Inherit;False;1;0;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;18;-409.7951,-667.4998;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;3;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;136;1108.632,-784.4643;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;197;1340.994,-785.593;Inherit;False;Bolt;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;205;2543.772,-276.6715;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;203;2317.725,-286.0809;Inherit;False;Screen;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;206;2370.046,-129.9476;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;151;2131.279,-143.6628;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;92;2139.725,-346.5609;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;149;1898.771,-405.9924;Inherit;False;Property;_SuperchargedColor;SuperchargedColor;10;0;Create;True;0;0;0;False;0;False;0.5531816,0,1,1;0.5531816,0,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;142;1893.551,-227.3394;Inherit;False;Property;_BaseColor;BaseColor;11;0;Create;True;0;0;0;False;0;False;0,1,0.9831882,1;0,0.9215686,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;101;1598.056,-242.9749;Inherit;True;Property;_BatteryBase;BatteryBase;6;0;Create;True;0;0;0;False;0;False;-1;7d611076352158b448ae234ed9ae6996;7d611076352158b448ae234ed9ae6996;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;199;1885.189,-45.18941;Inherit;False;197;Bolt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;183;2202.668,-866.3294;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;184;2370.49,-910.0532;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;186;2370.775,-771.535;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0.02;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;177;2595.293,-766.3247;Inherit;True;Property;_BatteryCrank;BatteryCrank;7;0;Create;True;0;0;0;False;0;False;-1;4ba35876c2cab6345b8d3f1056913810;4ba35876c2cab6345b8d3f1056913810;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;185;2687.492,-926.8938;Inherit;False;Rectangle;-1;;10;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;180;2948.893,-917.2455;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;192;3204.67,-905.5291;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;193;3155.242,-767.384;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;181;2922.658,-670.6426;Inherit;False;Property;_CrankColor;CrankColor;13;0;Create;True;0;0;0;False;0;False;0,0,0,1;0.5,0.5,0.5,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;198;2018.506,-855.4447;Inherit;False;196;Offset_Level;1;0;OBJECT;;False;1;FLOAT;0
WireConnection;154;0;152;0
WireConnection;154;1;64;0
WireConnection;84;0;75;0
WireConnection;196;0;75;0
WireConnection;88;0;87;0
WireConnection;88;1;196;0
WireConnection;66;0;88;0
WireConnection;65;1;66;0
WireConnection;87;0;84;0
WireConnection;87;1;86;0
WireConnection;75;0;67;0
WireConnection;67;0;71;0
WireConnection;67;1;90;0
WireConnection;71;0;89;0
WireConnection;71;1;90;0
WireConnection;25;0;24;0
WireConnection;24;0;18;0
WireConnection;118;0;102;1
WireConnection;155;0;63;0
WireConnection;120;0;159;1
WireConnection;102;1;61;0
WireConnection;60;0;63;0
WireConnection;159;1;160;0
WireConnection;160;1;161;0
WireConnection;61;1;105;0
WireConnection;105;0;155;0
WireConnection;161;0;60;0
WireConnection;93;1;95;0
WireConnection;173;0;18;0
WireConnection;28;0;173;0
WireConnection;28;1;93;1
WireConnection;165;0;28;0
WireConnection;165;1;164;0
WireConnection;95;1;94;0
WireConnection;94;0;172;0
WireConnection;94;1;25;0
WireConnection;172;0;88;0
WireConnection;86;0;84;0
WireConnection;86;1;8;0
WireConnection;64;1;65;0
WireConnection;152;0;205;0
WireConnection;152;1;162;0
WireConnection;162;0;199;0
WireConnection;162;1;163;0
WireConnection;191;0;192;0
WireConnection;191;1;154;0
WireConnection;191;2;193;0
WireConnection;21;0;191;0
WireConnection;171;0;163;0
WireConnection;42;1;171;0
WireConnection;63;0;18;0
WireConnection;18;0;5;0
WireConnection;136;0;118;0
WireConnection;136;1;120;0
WireConnection;197;0;136;0
WireConnection;205;0;203;0
WireConnection;205;1;206;0
WireConnection;203;0;92;0
WireConnection;203;1;204;0
WireConnection;203;2;101;1
WireConnection;206;0;151;0
WireConnection;151;0;101;1
WireConnection;151;1;199;0
WireConnection;92;0;198;0
WireConnection;92;2;149;0
WireConnection;92;3;142;0
WireConnection;183;0;198;0
WireConnection;184;1;183;0
WireConnection;177;1;186;0
WireConnection;185;1;184;0
WireConnection;180;0;185;0
WireConnection;180;1;177;4
WireConnection;180;2;101;4
WireConnection;192;0;180;0
WireConnection;193;0;180;0
WireConnection;193;1;181;0
ASEEND*/
//CHKSM=B502AA6127C8141BC2F35FB2EC888B01151EBFD9