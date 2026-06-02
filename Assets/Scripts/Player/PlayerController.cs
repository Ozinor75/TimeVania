using System;
using System.Collections;
using System.IO;
using NUnit.Framework.Internal;
using UnityEditor;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.HID;
using UnityEngine.UI;

public class PlayerController : MonoBehaviour
{
    [Header("Player Stats")]
    public float effectiveSpeed;
    public float dashCost;
    public float dashBoxSize;
    public float DashDecalage;
    
    [Header("Movement Progression")]
    public float acceleration = 25f;
    public float deceleration = 40f;
    public float minJoystick;
    private float currentSpeedX = 0f;
    
    [Header("Pushback")]
    public float pushbackForceX = 10f;
    public float pushbackForceY = 6f;
    public float pushbackDuration = 0.15f;
    public float iFrameDuration = 0.15f;

    private bool isPushedBack = false;
    private float pushbackTimer = 0f;
    private Vector2 pushbackVelocity;

    [Header("CoyotEtime")]
    public float coyotETimer;
    public float coyotE;

    [Header("Player refs")]
    public InputManager inputManager;
    public CustomInputs playerControls;
    private PlayerFeedback playerFeedback;
    private ColliderController colliderController;
    public Rigidbody2D rb;
    private CapsuleCollider2D selfCollider;
    public PlayerTimer timerController;
    private PlayerBoost playerBoost;
    private PlayerSound playerSound;
    public GlobalTime globalTime;
    private LineRenderer line;
    private Image blackScreen;
    private Color blackScreenColor;
    public Vector2 savePoint;
    public Transform respawnPoint;
    public Transform tempRespawn;

   
    [Header("Player Debug")]
    public bool isGrounded = true;
    [HideInInspector] public Vector2 hookStickDirection;
    public Transform boostTrigger;
    public Transform doorTrigger;
    public bool onStation = false;
    public bool onBoost = false;
    public bool isCharging = false;
    public bool isStarting;
    private bool isDashing = false;
    public bool isTouchable = true;
    public bool isRespawning = false;
    public bool isJumping = false;
    public float movementUpDown;
    public float movementLeftRight;
    [HideInInspector] public Vector2 movement;
    public Vector2 StartPos; //pos de départ pour restart
    public bool CanMove = false;
    public bool canDash = false;
    private float t = 0f;
    
    [HideInInspector] public Vector2 platformVelocity = Vector2.zero;

    [Header("DoubleJump & WallJump")]
    
    public bool DoubleJumpCapacity = true;
    [HideInInspector] public bool hasDoubleJumped;
    [HideInInspector] public bool canDoubleJump;
    public float doubleJumpCost;

    public bool WallJumpCapacity = true;
    public bool isWallSliding;
    [HideInInspector] public bool hasWallJumped;
    [HideInInspector] public float wallJumpDir;
    public float jumpCost;
    
    [HideInInspector] public bool lockGroundCheck;
    private float lockGroundCheckDuration = 0.1f;
    
    private void OnEnable()
    {
        if (playerControls == null)
            playerControls = new CustomInputs();
        
        playerControls.Enable();
    }
    private void OnDisable()
    {
        playerControls.Disable();
    }
    
    void Start()
    {
        isStarting = true;
        Physics2D.queriesStartInColliders = false;
        
        inputManager = FindAnyObjectByType<InputManager>();
        selfCollider = GetComponent<CapsuleCollider2D>();
        rb = GetComponent<Rigidbody2D>();
        
        playerBoost = GetComponent<PlayerBoost>();
        Physics2D.gravity = new Vector2(0, -playerBoost.gravity);
        playerSound = FindFirstObjectByType<PlayerSound>();
        playerFeedback = FindFirstObjectByType<PlayerFeedback>();
        colliderController = FindFirstObjectByType<ColliderController>();
        line = GetComponent<LineRenderer>();
        
        timerController = GetComponent<PlayerTimer>();
        timerController.tMult = playerBoost.baseConsumptionMult;
        
        StartPos = transform.position;
        
        //blackScreen = GameObject.FindGameObjectWithTag("BlackScreen").GetComponent<Image>();
        //blackScreenColor = Color.black;

        StartCoroutine(LoadStart());
        //StartCoroutine(BlackFade());
        Respawn();
        playerSound.MusicDefault();
        isStarting = false;
    }
    
    public IEnumerator LoadStart()
    {
        if (File.Exists(Application.persistentDataPath + "/save" + ".json"))
        {
            yield return new WaitForSecondsRealtime(0.05f);
            SaveSystem.Load();
        }
    }
    
    public IEnumerator BlackFade()
    {
        while (blackScreenColor.a > 0f)
        {
            blackScreenColor.a -= Time.deltaTime;
            blackScreen.color = blackScreenColor;
            yield return null;
        }
    }
    
    void FixedUpdate()
    {
        Physics2D.gravity = new Vector2(0, -playerBoost.gravity); 
        if (isPushedBack)
        {
            rb.linearVelocity = new Vector2(pushbackVelocity.x, rb.linearVelocityY);

            pushbackTimer -= Time.fixedDeltaTime;
            if (pushbackTimer <= 0f)
            {
                isPushedBack = false;
            }
            return;
        }
        
        if (CanMove && !isJumping)
            rb.linearVelocity = movement;
        else if (CanMove && isJumping)
            rb.linearVelocityX = movement.x;
        else if (!CanMove && !isJumping)
            rb.linearVelocity = Vector2.zero;
        
        if (rb.linearVelocityY < 0f && isJumping)
        {
            isJumping = false;
            canDoubleJump = true;
        }
    }
    
    public void MakeJump()
    {
        if (isGrounded || coyotE >= 0f)
        {
            isJumping = true;
            rb.linearVelocityY = playerBoost.jumpForce;
            UngroundJumpPlayer();
            coyotE = 0f;
            // Debug.Log("Jump");
            if (!timerController.isCharging)
                timerController.t -= jumpCost;
        }
        
        // else if (isWallSliding && !hasWallJumped && WallJumpCapacity)
        // {
        //     // rb.linearVelocity = new Vector2(playerBoost.jumpForce * Mathf.Sign(wallJumpDir) / 2, playerBoost.jumpForce / 2);
        //     rb.linearVelocityX = playerBoost.jumpForce * Mathf.Sign(wallJumpDir) / 2;
        //     rb.linearVelocityY= playerBoost.jumpForce / 2;
        //     isJumping = true;
        //     isWallSliding = false;
        //     hasWallJumped = true;
        //     UngroundPlayer();
        //     coyotE = 0f;
        //     Debug.Log("W Jump");
        //     
        //     if (!timerController.isCharging)
        //         timerController.t -= jumpCost;
        // }
        
        // else if (canDoubleJump && !hasDoubleJumped && DoubleJumpCapacity)
        // {
        //     rb.linearVelocityY = playerBoost.jumpForce;
        //     isJumping = true;
        //     canDoubleJump = false;
        //     hasDoubleJumped = true;
        //     lockGroundCheck = true;
        //     Debug.Log("D Jump");
        //     
        //     if (!timerController.isCharging)
        //         timerController.t -= doubleJumpCost;
        // }
    }
    
    public IEnumerator MakeRespawn()
    {
        // Debug.Log("Respawn");
        isRespawning = true;
        CanMove = false;
        if (transform.parent != null)
            transform.SetParent(null);
        playerSound.Death();
        //while (blackScreenColor.a < 1f)
        //{
            //blackScreenColor.a += Time.deltaTime;
            //blackScreen.color = blackScreenColor;
            //yield return null;
        //}
        
        // to do 
        
        if (transform.parent != null)
        {
            transform.SetParent(null);
        }
        rb.position = new Vector2(respawnPoint.position.x, respawnPoint.position.y);
        yield return new WaitForSeconds(1f);
        Debug.Log("die screen");
        yield return new WaitForSeconds(3f);
        Respawn();
        playerSound.StartSound();
    }
    public void Respawn()
    {
        if (!isStarting)
            inputManager.ActivateStation.Invoke();
        timerController.tMult = playerBoost.baseConsumptionMult;
        timerController.t = timerController.timer;
        isRespawning = false;
        CanMove = true;
        colliderController.isOnPlatform = false;
        currentSpeedX = 0f;
    }
    public void CrushRespawn()
    {
        rb.simulated = false;
        transform.position = tempRespawn.position;
        transform.SetParent(null);
        rb.simulated = true;
    }
    private IEnumerator DashLine()
    {
        yield return new WaitForSecondsRealtime(0.2f);
        line.enabled = false;
    }
    public void ChangeGear()
    {
        timerController.tMult = playerBoost.boostedConsumptionMult;
    }
    public void ResetGear()
    {
        timerController.tMult = playerBoost.baseConsumptionMult;
    }
    
    private void Update()
    {
        if (!isPushedBack && !isRespawning)
        {
            movementLeftRight = playerControls.Player.Direction.ReadValue<Vector2>().x;
            movementUpDown = playerControls.Player.Direction.ReadValue<Vector2>().y;
            hookStickDirection = playerControls.Player.HookDirection.ReadValue<Vector2>();
        }
        
        float targetSpeedX = movementLeftRight * effectiveSpeed;
        float currentAccel = (Mathf.Abs(movementLeftRight) > minJoystick) ? acceleration : deceleration;
        currentSpeedX = Mathf.MoveTowards(currentSpeedX, targetSpeedX, currentAccel * Time.deltaTime);
        movement = new Vector2(currentSpeedX, rb.linearVelocityY);
        
        if (timerController.t <= 0 && !isRespawning) StartCoroutine(MakeRespawn());

        if (lockGroundCheck)
        {
            lockGroundCheckDuration -= Time.deltaTime;

            if (lockGroundCheckDuration <= 0)
            {
                lockGroundCheckDuration = 0.1f;
                lockGroundCheck = false;
            }
        }
        
        if (coyotE >= 0f && !isGrounded)
        {
            coyotE -= Time.deltaTime;
        }
    }

    public void MakeIFrame()
    {
        if (isTouchable)
            StartCoroutine(IFrame());
    }
    public IEnumerator IFrame()
    {
        isTouchable = false;
        yield return new WaitForSecondsRealtime(iFrameDuration);
        isTouchable = true;
    }
    
    public void Pushback(Vector2 hitPosition)
    {
        if (isTouchable)
        {
            Vector2 dir = ((Vector2)transform.position - hitPosition).normalized;
        
            float x = Mathf.Sign(dir.x) * pushbackForceX;
            float y = pushbackForceY;

            pushbackVelocity = new Vector2(x, y);
            isPushedBack = true;
            pushbackTimer = pushbackDuration;
            isJumping = false;
            t = 0f;
            rb.linearVelocity = pushbackVelocity;
            currentSpeedX = 0f;
            playerFeedback.InvokeEvent(playerFeedback.pushback);
            playerSound.HurtSound();
        }
    }
    
    public void ExitStation()
    {
        onStation =  false;
        isCharging = false;
    }
    public void GroundPlayer()
    {
        // Debug.Log("GroundPlayer");
        isGrounded = true;
        coyotE = coyotETimer;
        isJumping = false;
        canDoubleJump = false;
        hasDoubleJumped = false;
        hasWallJumped = false;
        effectiveSpeed = playerBoost.groundSpeed;
        playerFeedback.InvokeEvent(playerFeedback.landing);
    }
    public void UngroundPlayer()
    {
        // Debug.Log("UnGroundPlayer");
        canDoubleJump = true;
        isGrounded = false;
        lockGroundCheck = true;
        // coyotE = 0f;
        effectiveSpeed = playerBoost.airSpeed;
    }    
    
    public void UngroundJumpPlayer()
    {
        // Debug.Log("UnGroundPlayer");
        canDoubleJump = true;
        isGrounded = false;
        lockGroundCheck = true;
        coyotE = 0f;
        effectiveSpeed = playerBoost.airSpeed;
    }
    
    public void MakeDash()
    
    {
        // Debug.Log("Making Dash");
        Vector3[] posArray = new Vector3[2];
        Vector2 endPos = playerControls.Player.Direction.ReadValue<Vector2>().normalized;
        Vector2 test = new Vector2(transform.position.x, transform.position.y + DashDecalage);
        // Vector2 perp = new Vector2(-endPos.y, endPos.x) * dashBoxSize;
    
        // // 2. Définition des 4 coins de la zone balayée par le CircleCast
        // Vector2 startTop = test + perp;
        // Vector2 startBottom = test - perp;
        // Vector2 endDebugTop = startTop + (endPos * playerBoost.dashDistance);
        // Vector2 endDebugBottom = startBottom + (endPos * playerBoost.dashDistance);

        // // 3. Dessin des lignes (affichées pendant 2 secondes pour bien les voir dans la fenêtre Scene)
        // float debugTime = 2f;
        // Debug.DrawLine(startTop, endDebugTop, Color.red, debugTime);       // Ligne supérieure
        // Debug.DrawLine(startBottom, endDebugBottom, Color.red, debugTime); // Ligne inférieure
        // Debug.DrawLine(endDebugTop, endDebugBottom, Color.red, debugTime); // Capot avant
        // Debug.DrawLine(startTop, startBottom, Color.red, debugTime);
        RaycastHit2D checkDash = Physics2D.CircleCast(test, dashBoxSize, endPos, playerBoost.dashDistance);

        rb.gravityScale = 0f;
        rb.linearVelocity = Vector2.zero;
        currentSpeedX = 0f;
        posArray[0] = test;
            
        if (checkDash)
            endPos = checkDash.point;
        
        else
        {
            endPos *= playerBoost.dashDistance;
            endPos += rb.position;
        }
        
        // Debug.DrawLine(test, endPos, Color.green);
        
        posArray[1] = endPos;
        line.SetPositions(posArray);
        line.enabled = true;
        
        rb.gravityScale = 1f;
        rb.position = endPos;
        if (!timerController.isCharging)
            timerController.t -= dashCost;
        StartCoroutine(DashLine());
    }
}