using System;
using System.Collections.Generic;
using Unity.Collections;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Serialization;
using Debug = UnityEngine.Debug;

public enum BoostStates
{
    Gear1,
    Gear2,
    Gear3,
    DEBUG
}

public class PlayerPresets
{
    [Header("Stats")]
    public float groundSpeed;
    public float airSpeed;
    public float jumpForce;
    public float dashDistance;
    public float gravityForce;
    public float slideSpeed;
    public float timerMult;
    public float globalWorldTime;

    public PlayerPresets(float groundSpeed, float airSpeed, float jumpForce, float dashDistance, float gravityForce, float slideSpeed, float timerMult, float globalWolrdTime)
    {
        this.groundSpeed = groundSpeed;
        this.airSpeed = airSpeed;
        this.jumpForce = jumpForce;
        this.dashDistance = dashDistance;
        this.gravityForce = gravityForce;
        this.slideSpeed = slideSpeed;
        this.timerMult = timerMult;
        this.globalWorldTime = globalWolrdTime;
    }
    
    public static PlayerPresets Slow = new(10f, 5f, 18f, 12f,29.4f, 250f,3f,2f);
    public static PlayerPresets Mid = new(10f, 5f, 18f, 12f,29.4f, 250f,1f,2f);
    public static PlayerPresets Swift = new(10f, 5f, 18f, 12f,29.4f, 250f,3f,2f);
}

public class PlayerBoost : MonoBehaviour
{
    [Header("References")]
    private CustomInputs playerControls;
    private PlayerTimer timerController;
    public Material mat;
    public Color SlowColor;
    public Color MidColor;
    public Color SwiftColor;

    [Header("Debug Values")]
    public float DEBUG_groundSpeed;
    public float DEBUG_airSpeed;
    public float DEBUG_jumpForce;
    public float DEBUG_dashDistance;
    public float DEBUG_gravityForce;
    public float DEBUG_timerMult;
    public float DEBUG_globalWorldTime;
    
    public BoostStates boostState;
    private PlayerController playerController;
    public float totalTimerMult;
    
    void Start()
    {
        timerController = GetComponent<PlayerTimer>();
    }

    public void MidBoostState()
    {
        boostState = BoostStates.Gear2;
    }
    
    public void IncreaseBoostState()
    {
        boostState++;
    }

    public void DecreaseBoostState()
    {
        boostState--;
    }
    public PlayerPresets ReturnGearSpeed()
    { 
        PlayerPresets preset = PlayerPresets.Slow;

        
        switch (boostState)
        {
            case BoostStates.Gear1:
                preset = PlayerPresets.Slow;
                mat.SetColor("_LEDsColor", SlowColor);
                break;
                
            case BoostStates.Gear2:
                preset = PlayerPresets.Mid;
                mat.SetColor("_LEDsColor", MidColor);
                break;
                
            case BoostStates.Gear3:
                preset = PlayerPresets.Swift;
                mat.SetColor("_LEDsColor", SwiftColor);
                break;

            case BoostStates.DEBUG:
                mat.color = Color.white;
                break;
        }
        return preset;
    }
}
