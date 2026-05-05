using System;
using System.Collections;
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
    public Vector2 dashBoxSize;
    
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
    public Rigidbody2D rb;
    private CapsuleCollider2D selfCollider;
    public PlayerTimer timerController;
    private PlayerBoost playerBoost;
    private PlayerSound playerSound;
    public GlobalTime globalTime;
    private LineRenderer line;
    private Image blackScreen;
    private Color blackScreenColor;
    public Transform respawnPoint;
    public Transform tempRespawn;

   
    [Header("Player Debug")]
    public bool isGrounded = true;
    [HideInInspector] public Vector2 hookStickDirection;
    public bool onStation = false;
    public bool isCharging = false;
    private bool isDashing = false;
    public bool isTouchable = true;
    public bool isRespawning = false;
    public bool isJumping = false;
    public float movementUpDown;
    public float movementLeftRight;
    [HideInInspector] public Vector2 movement;
    public Vector2 StartPos; //pos de départ pour restart
    public bool CanMove = false;
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
        Physics2D.queriesStartInColliders = false;
        Physics2D.gravity = new Vector2(0, -35);
        
        inputManager = FindAnyObjectByType<InputManager>();
        selfCollider = GetComponent<CapsuleCollider2D>();
        rb = GetComponent<Rigidbody2D>();
        
        playerBoost = GetComponent<PlayerBoost>();
        playerSound = FindFirstObjectByType<PlayerSound>();
        line = GetComponent<LineRenderer>();
        
        timerController = GetComponent<PlayerTimer>();
        timerController.tMult = playerBoost.baseConsumptionMult;
        
        StartPos = transform.position; //sauvegarde position de départ
        
        blackScreen = GameObject.FindGameObjectWithTag("BlackScreen").GetComponent<Image>();
        blackScreenColor = Color.black;
        
        StartCoroutine(BlackFade());
        Respawn();
    }

    public IEnumerator BlackFade()
    {
        while (blackScreenColor.a > 0f)
        {
            blackScreenColor.a -= Time.deltaTime;
            blackScreen.color = blackScreenColor;
            yield return null;
        }
        Respawn();
    }
    
    void FixedUpdate()
    {
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
            rb.linearVelocityY = playerBoost.jumpForce;
            isJumping = true;
            UngroundPlayer();
            coyotE = 0f;
            Debug.Log("Jump");
            if (!timerController.isCharging)
                timerController.t -= jumpCost;
        }
        
        else if (isWallSliding && !hasWallJumped && WallJumpCapacity)
        {
            // rb.linearVelocity = new Vector2(playerBoost.jumpForce * Mathf.Sign(wallJumpDir) / 2, playerBoost.jumpForce / 2);
            rb.linearVelocityX = playerBoost.jumpForce * Mathf.Sign(wallJumpDir) / 2;
            rb.linearVelocityY= playerBoost.jumpForce / 2;
            isJumping = true;
            isWallSliding = false;
            hasWallJumped = true;
            UngroundPlayer();
            coyotE = 0f;
            Debug.Log("W Jump");
            
            if (!timerController.isCharging)
                timerController.t -= jumpCost;
        }
        
        else if (canDoubleJump && !hasDoubleJumped && DoubleJumpCapacity)
        {
            rb.linearVelocityY = playerBoost.jumpForce;
            isJumping = true;
            canDoubleJump = false;
            hasDoubleJumped = true;
            lockGroundCheck = true;
            Debug.Log("D Jump");
            
            if (!timerController.isCharging)
                timerController.t -= doubleJumpCost;
        }
    }
    
    public IEnumerator MakeRespawn()
    {
        Debug.Log("Respawn");
        isRespawning = true;
        CanMove = false;
        if (transform.parent != null)
            transform.SetParent(null);
        playerSound.Death();
        while (blackScreenColor.a < 1f)
        {
            blackScreenColor.a += Time.deltaTime;
            blackScreen.color = blackScreenColor;
            yield return null;
        }

        if (transform.parent != null)
        {
            transform.SetParent(null);
        }
        rb.position = new Vector2(respawnPoint.position.x, respawnPoint.position.y);
        yield return new WaitForSeconds(1f);
        while (blackScreenColor.a > 0f)
        {
            blackScreenColor.a -= Time.deltaTime;
            blackScreen.color = blackScreenColor;
            yield return null;
        }
        Respawn();
        playerSound.StartSound();
    }
    public void Respawn()
    {
        inputManager.ActivateStation.Invoke();
        timerController.tMult = playerBoost.baseConsumptionMult;
        timerController.t = timerController.timer;
        isRespawning = false;
        CanMove = true;
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
        
        movement = new Vector2(movementLeftRight * effectiveSpeed, rb.linearVelocityY);
        
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
        }
    }
    public void ExitStation()
    {
        onStation =  false;
        isCharging = false;
    }
    public void GroundPlayer()
    {
        Debug.Log("GroundPlayer");
        isGrounded = true;
        coyotE = coyotETimer;
        isJumping = false;
        canDoubleJump = false;
        hasDoubleJumped = false;
        hasWallJumped = false;
        effectiveSpeed = playerBoost.groundSpeed;
    }
    public void UngroundPlayer()
    {
        Debug.Log("UnGroundPlayer");
        canDoubleJump = true;
        isGrounded = false;
        lockGroundCheck = true;
        // coyotE = 0f;
        effectiveSpeed = playerBoost.airSpeed;
    }
    public void MakeDash()
    {
        Vector3[] posArray = new Vector3[2];
        Vector2 endPos = playerControls.Player.Direction.ReadValue<Vector2>().normalized;
        Vector2 test = new Vector2(transform.position.x, transform.position.y + 0.3f);
        RaycastHit2D checkDash = Physics2D.CircleCast(test, 0.1f, endPos, playerBoost.dashDistance);

        rb.gravityScale = 0f;
        rb.linearVelocity = Vector2.zero;
        posArray[0] = test;
            
        if (checkDash)
            endPos = checkDash.point;
        
        else
        {
            endPos *= playerBoost.airSpeed;
            endPos += rb.position;
        }
        
        Debug.DrawLine(test, endPos, Color.green);
        
        posArray[1] = endPos;
        line.SetPositions(posArray);
        line.enabled = true;
        
        rb.position = endPos;
        rb.gravityScale = 1f;
        if (!timerController.isCharging)
            timerController.t -= dashCost;
        StartCoroutine(DashLine());
    }
}