using System;
using System.Collections.Generic;
using Unity.Collections;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Serialization;
using Debug = UnityEngine.Debug;

public enum BoostStates
{
    // Gear1,
    LowEnergy,
    BaseMode,
    Boost,
    SuperBoost,
    DEBUG
}

public class PlayerPresets
{
    [Header("Stats")]
    public float vMax;
    public float groundSpeed;
    public float airSpeed;
    public float jumpForce;
    public float gravityForce;
    public float timerMult;

    public PlayerPresets(/*float vMax,*/float groundSpeed, float airSpeed, float jumpForce, float gravityForce,float timerMult)
    {
        // this.vMax = vMax;
        this.groundSpeed = groundSpeed;
        this.airSpeed = airSpeed;
        this.jumpForce = jumpForce;
        this.gravityForce = gravityForce;
        this.timerMult = timerMult;
    }
    
    // public static PlayerPresets SuperSlow = new(3f,3f, 1.5f, 3.5f, 0.25f);  // Truc de base, chiant donc lent, mais écoulement du timer lent
    public static PlayerPresets Slow = new(/*6f,*/6f, 3f, 7f, 5f,0.5f);         // Ici un peu plus haut, jpense lent mais un minimum agréable, c'est lécoulement normal
    public static PlayerPresets Mid = new(/*9f,*/9f, 5f, 12f, 10f,1f);       // Mid, ptet ici l'écoulement de base
    public static PlayerPresets Swift = new(/*14f,*/14f, 8f, 17f, 15f,2f);    // les chaussures qui courent vite
    public static PlayerPresets SuperSwift = new(/*22f,*/22f, 10f, 22f, 20f,5f);   // Flash McQueen
}

public class PlayerBoost : MonoBehaviour
{
    [Header("References")]
    private CustomInputs playerControls;
    private PlayerTimer timerController;
    public Material mat;

    [Header("Debug Values")]
    // public float DEBUG_vMax;
    public float DEBUG_groundForce;
    public float DEBUG_airForce;
    public float DEBUG_jumpForce;
    public float DEBUG_gravityForce;
    public float DEBUG_timerMult;
    
    public BoostStates boostState;
    private PlayerController playerController;
    public float totalTimerMult;
    
    void Start()
    {
        timerController = GetComponent<PlayerTimer>();
    }

    public PlayerPresets ReturnGearSpeed()
    { 
        PlayerPresets preset = PlayerPresets.Slow;

        switch (boostState)
        {
            // case BoostStates.Gear1:
            //     preset = PlayerPresets.SuperSlow;
            //     mat.color = new Color(0f, 0f, 1f);
            //     break;
                
            case BoostStates.LowEnergy:
                preset = PlayerPresets.Slow;
                mat.color = new Color(0f, 0f, 1f);
                break;
                
            case BoostStates.BaseMode:
                preset = PlayerPresets.Mid;
                mat.color = new Color(0f, 1f, 1f);
                break;
                
            case BoostStates.Boost:
                preset = PlayerPresets.Swift;
                mat.color = new Color(1f, 1f, 0f);
                break;
                
            case BoostStates.SuperBoost:
                preset = PlayerPresets.SuperSwift;
                mat.color = new Color(1f, 0f, 0f);
                break;
            case BoostStates.DEBUG:
                preset = new PlayerPresets(/*DEBUG_vMax,*/ DEBUG_groundForce,
                                            DEBUG_airForce, DEBUG_jumpForce,
                                            DEBUG_gravityForce, DEBUG_timerMult);
                mat.color = Color.white;
                break;
        }
        
        Debug.Log(preset.groundSpeed);
        return preset;
    }
}
