using UnityEngine;
using UnityEngine.Serialization;

public class FollowPlayerHolder : MonoBehaviour
{
    public Transform PlayerPos;
    public CustomInputs playerControls;
    
    public Vector3 targetPos;
    private Vector3 realVelocity = new Vector3(2, 0, 0);

    public float offset = 3f;
    public float offsetY = 10f;
    
    public float smoothTimeX = 0.25f;
    public float smoothTimeY = 0.3f; // Retour à la petite valeur classique
    private float velocityY = 0f;    // Retour de la vélocité pour l'axe Y
    
    private bool isRecovering = false;
    
    private float realOffset = 0f;
    private float realOffsetY = 0f;

    private float timer;
    public float timeUp;

    private bool Ground;
    
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
        timer = timeUp;
    }
    
    void LateUpdate()
    {   
        if (playerControls.Player.Direction.ReadValue<Vector2>().x > 0.1)
            realOffset = -offset;
        else if (playerControls.Player.Direction.ReadValue<Vector2>().x < -0.1)
            realOffset = offset;
        else
            realOffset = 0f;

        float targetY = PlayerPos.position.y;
        float newY = transform.position.y;

        if (Ground)
        {
            if (timer < 0f && !isRecovering)
            {
                isRecovering = true;
                velocityY = 0f;
            }

            if (isRecovering)
            {
                newY = Mathf.SmoothDamp(transform.position.y, targetY, ref velocityY, smoothTimeY);
                realOffsetY = newY - targetY; 
                
                if (Mathf.Abs(transform.position.y - targetY) < 0.05f)
                {
                    isRecovering = false;
                    newY = targetY;
                    velocityY = 0f;
                    realOffsetY = 0f;
                }
                
                timer = timeUp; 
            }
            else
            {
                newY = targetY;
                velocityY = 0f;
                timer = timeUp;
                realOffsetY = 0f;
            }
        }
        else
        {
            timer -= Time.deltaTime;
            Debug.Log(timer);

            if (timer < 0f)
            {
                float downTargetY = targetY - offsetY;
                newY = Mathf.SmoothDamp(transform.position.y, downTargetY, ref velocityY, smoothTimeY);
                realOffsetY = newY - targetY;
            }
            else
            {
                if (isRecovering)
                {
                    newY = Mathf.SmoothDamp(transform.position.y, targetY, ref velocityY, smoothTimeY);
                    realOffsetY = newY - targetY;
                }
                else
                {
                    newY = targetY;
                    velocityY = 0f;
                    realOffsetY = 0f;
                }
            }
        }
        
        targetPos = new Vector3(PlayerPos.position.x + realOffset, PlayerPos.position.y + realOffsetY, PlayerPos.position.z);
        
        float newX = Mathf.SmoothDamp(transform.position.x, targetPos.x, ref realVelocity.x, smoothTimeX);
        
        transform.position = new Vector3(newX, newY, 0f);
    }

    public void ThereIsGround()
    {
        Ground = true;
    }    
    public void NoGround()
    {
        Ground = false;
    }
}